// Service pour interagir avec Ollama en local
export interface Message {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface OllamaResponse {
  model: string;
  created_at: string;
  message: {
    role: string;
    content: string;
  };
  done: boolean;
}

export class OllamaService {
  private baseUrl: string;
  private model: string;

  constructor(baseUrl?: string, model: string = 'codellama') {
    // Utiliser la variable d'environnement si disponible (Docker), sinon localhost
    this.baseUrl = baseUrl || process.env.OLLAMA_BASE_URL || 'http://localhost:11434';
    this.model = model;
    
    console.log('[OllamaService] Initialized with:');
    console.log('  - Base URL:', this.baseUrl);
    console.log('  - Model:', this.model);
    console.log('  - OLLAMA_BASE_URL env:', process.env.OLLAMA_BASE_URL);
  }

  /**
   * Vérifie si Ollama est accessible
   */
  async checkConnection(): Promise<boolean> {
    try {
      console.log(`[OllamaService] Checking connection to ${this.baseUrl}/api/tags`);
      const response = await fetch(`${this.baseUrl}/api/tags`);
      const isOk = response.ok;
      console.log(`[OllamaService] Connection check result: ${isOk ? 'SUCCESS' : 'FAILED'} (status: ${response.status})`);
      return isOk;
    } catch (error: any) {
      console.error('[OllamaService] Connection error:', error.message);
      return false;
    }
  }

  /**
   * Liste les modèles disponibles
   */
  async listModels(): Promise<string[]> {
    try {
      const response = await fetch(`${this.baseUrl}/api/tags`);
      const data = await response.json();
      return data.models?.map((m: any) => m.name) || [];
    } catch (error) {
      console.error('Error listing models:', error);
      return [];
    }
  }

  /**
   * Vérifie si un modèle spécifique est installé
   */
  async isModelInstalled(modelName?: string): Promise<boolean> {
    try {
      const models = await this.listModels();
      const targetModel = modelName || this.model;

      // Vérifier si le modèle exact ou une variante existe
      const isInstalled = models.some(m =>
        m === targetModel ||
        m.startsWith(targetModel + ':') ||
        m === targetModel + ':latest'
      );

      console.log(`[OllamaService] Model '${targetModel}' installed:`, isInstalled);
      console.log(`[OllamaService] Available models:`, models);

      return isInstalled;
    } catch (error) {
      console.error('Error checking model installation:', error);
      return false;
    }
  }

  /**
   * Envoie un message à Ollama et reçoit la réponse complète
   */
  async chat(messages: Message[]): Promise<string> {
    try {
      const requestBody = {
        model: this.model,
        messages: messages,
        stream: false,
      };

      console.log('[OllamaService] Sending chat request:', {
        url: `${this.baseUrl}/api/chat`,
        model: this.model,
        messageCount: messages.length
      });

      const response = await fetch(`${this.baseUrl}/api/chat`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody),
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('[OllamaService] Error response:', {
          status: response.status,
          statusText: response.statusText,
          body: errorText
        });

        // Si le modèle n'existe pas, donner un message plus explicite
        if (response.status === 404) {
          throw new Error(`Model '${this.model}' not found. Please ensure the model is installed with: docker exec ai-agent-ollama ollama pull ${this.model}`);
        }

        throw new Error(`Ollama error: ${response.statusText} - ${errorText}`);
      }

      const data: OllamaResponse = await response.json();
      console.log('[OllamaService] Chat response received successfully');
      return data.message.content;
    } catch (error) {
      console.error('Error chatting with Ollama:', error);
      throw error;
    }
  }

  /**
   * Envoie un message à Ollama et reçoit la réponse en streaming
   */
  async *chatStream(messages: Message[]): AsyncGenerator<string> {
    try {
      const response = await fetch(`${this.baseUrl}/api/chat`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: this.model,
          messages: messages,
          stream: true,
        }),
      });

      if (!response.ok) {
        throw new Error(`Ollama error: ${response.statusText}`);
      }

      const reader = response.body?.getReader();
      if (!reader) {
        throw new Error('No response body');
      }

      const decoder = new TextDecoder();
      let buffer = '';

      while (true) {
        const { done, value } = await reader.read();
        
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';

        for (const line of lines) {
          if (line.trim()) {
            try {
              const data: OllamaResponse = JSON.parse(line);
              if (data.message?.content) {
                yield data.message.content;
              }
            } catch (e) {
              console.error('Error parsing JSON:', e);
            }
          }
        }
      }
    } catch (error) {
      console.error('Error streaming from Ollama:', error);
      throw error;
    }
  }

  /**
   * Change le modèle utilisé
   */
  setModel(model: string) {
    this.model = model;
  }

  /**
   * Obtient le modèle actuel
   */
  getModel(): string {
    return this.model;
  }
}

export const ollamaService = new OllamaService();
