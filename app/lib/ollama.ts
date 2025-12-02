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
   * Envoie un message à Ollama et reçoit la réponse complète
   */
  async chat(messages: Message[]): Promise<string> {
    try {
      const response = await fetch(`${this.baseUrl}/api/chat`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: this.model,
          messages: messages,
          stream: false,
        }),
      });

      if (!response.ok) {
        throw new Error(`Ollama error: ${response.statusText}`);
      }

      const data: OllamaResponse = await response.json();
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
