import { NextRequest, NextResponse } from 'next/server';
import { OllamaService, Message } from '@/app/lib/ollama';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const ollama = new OllamaService();

export async function POST(req: NextRequest) {
  try {
    const { messages, stream, model } = await req.json();

    if (!messages || !Array.isArray(messages)) {
      return NextResponse.json(
        { error: 'Messages array is required' },
        { status: 400 }
      );
    }

    // Changer le modèle si spécifié
    if (model) {
      ollama.setModel(model);
    }

    // Vérifier la connexion à Ollama avant de traiter
    const isConnected = await ollama.checkConnection();
    if (!isConnected) {
      console.error('Ollama is not accessible');
      return NextResponse.json(
        { 
          error: 'Cannot connect to Ollama. Please ensure Ollama is running.',
          details: 'Check that Ollama container is started and healthy.'
        },
        { status: 503 }
      );
    }

    // Si le streaming est demandé
    if (stream) {
      const encoder = new TextEncoder();
      
      const customReadable = new ReadableStream({
        async start(controller) {
          try {
            for await (const chunk of ollama.chatStream(messages as Message[])) {
              controller.enqueue(encoder.encode(`data: ${JSON.stringify({ content: chunk })}\n\n`));
            }
            controller.enqueue(encoder.encode('data: [DONE]\n\n'));
            controller.close();
          } catch (error: any) {
            console.error('Streaming error:', error);
            controller.error(error);
          }
        },
      });

      return new NextResponse(customReadable, {
        headers: {
          'Content-Type': 'text/event-stream',
          'Cache-Control': 'no-cache',
          'Connection': 'keep-alive',
        },
      });
    }

    // Réponse non-streamée
    const response = await ollama.chat(messages as Message[]);
    
    return NextResponse.json({ 
      content: response,
      model: ollama.getModel() 
    });

  } catch (error: any) {
    console.error('Chat API error:', error);
    console.error('Error details:', {
      message: error.message,
      stack: error.stack,
      name: error.name
    });
    
    return NextResponse.json(
      { 
        error: error.message || 'Failed to process chat request',
        details: process.env.NODE_ENV === 'development' ? error.stack : undefined
      },
      { status: 500 }
    );
  }
}

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const action = searchParams.get('action');

    if (action === 'check') {
      const isConnected = await ollama.checkConnection();
      return NextResponse.json({ connected: isConnected });
    }

    if (action === 'models') {
      const models = await ollama.listModels();
      return NextResponse.json({ models });
    }

    return NextResponse.json(
      { error: 'Invalid action' },
      { status: 400 }
    );
  } catch (error: any) {
    console.error('Chat API error:', error);
    return NextResponse.json(
      { error: error.message || 'Failed to process request' },
      { status: 500 }
    );
  }
}
