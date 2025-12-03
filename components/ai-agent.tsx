'use client';

import { useState, useRef, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { FileText, Send, Loader2, CheckCircle, AlertCircle, Code, Download, Archive } from 'lucide-react';

interface Message {
  role: 'user' | 'assistant' | 'system';
  content: string;
  timestamp: Date;
}

interface SessionState {
  phase: 'upload' | 'analysis' | 'qa' | 'generation' | 'complete';
  specification?: string;
  messages: Message[];
  generatedFiles: Array<{ name: string; path: string }>;
  sessionDirectory?: string;
}

export default function AIAgent() {
  const [session, setSession] = useState<SessionState>({
    phase: 'upload',
    messages: [],
    generatedFiles: [],
  });
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [isConnected, setIsConnected] = useState<boolean | null>(null);
  const [selectedModel, setSelectedModel] = useState('qwen2.5-coder:1.5b');
  const [availableModels, setAvailableModels] = useState<string[]>([]);
  const scrollRef = useRef<HTMLDivElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Vérifier la connexion à Ollama au démarrage
  useEffect(() => {
    checkOllamaConnection();
    loadAvailableModels();
  }, []);

  // Auto-scroll vers le bas quand de nouveaux messages arrivent
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [session.messages]);

  const checkOllamaConnection = async () => {
    try {
      const response = await fetch('/api/chat?action=check');
      const data = await response.json();
      setIsConnected(data.connected);
    } catch (error) {
      setIsConnected(false);
    }
  };

  const loadAvailableModels = async () => {
    try {
      const response = await fetch('/api/chat?action=models');
      const data = await response.json();
      const models = data.models || [];
      setAvailableModels(models);

      // Si le modèle sélectionné n'est pas disponible, utiliser le premier disponible
      if (models.length > 0 && !models.includes(selectedModel)) {
        const preferredModels = [
          'qwen2.5-coder:1.5b',
          'deepseek-coder:1.3b',
          'tinyllama',
          'phi3:mini',
          'codellama',
          'llama3'
        ];

        // Chercher le premier modèle préféré disponible
        const foundModel = preferredModels.find(m =>
          models.some((am: string) => am === m || am.startsWith(m + ':'))
        );

        if (foundModel) {
          setSelectedModel(foundModel);
        } else {
          // Sinon, utiliser le premier modèle disponible
          setSelectedModel(models[0]);
        }
      }
    } catch (error) {
      console.error('Failed to load models:', error);
    }
  };

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    try {
      const text = await file.text();
      setSession({
        ...session,
        specification: text,
        phase: 'analysis',
      });

      // Démarrer l'analyse automatiquement
      await analyzeSpecification(text);
    } catch (error) {
      console.error('Error reading file:', error);
      addMessage('system', 'Erreur lors de la lecture du fichier.');
    }
  };

  const analyzeSpecification = async (spec: string) => {
    setIsLoading(true);
    
    const systemPrompt = `Tu es un architecte logiciel expert. Analyse cette spécification fonctionnelle et :
1. Identifie les fonctionnalités principales
2. Propose une architecture technique claire et modulaire
3. Liste les questions essentielles à clarifier avec le client
4. Suggère les technologies appropriées avec justification
5. Identifie les fichiers qui devront être créés (code + documentation)

Sois concis, structuré et précis dans ton analyse. Pense à la documentation dès le début.`;

    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          messages: [
            { role: 'system', content: systemPrompt },
            { role: 'user', content: `Spécification:\n\n${spec}` },
          ],
          model: selectedModel,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        // Afficher le message d'erreur du serveur
        const errorMessage = data.error || `HTTP error! status: ${response.status}`;
        const errorDetails = data.details || '';
        throw new Error(`${errorMessage}\n${errorDetails}`);
      }

      if (!data.content) {
        throw new Error('No content in response');
      }

      addMessage('assistant', data.content);

      setSession(prev => ({ ...prev, phase: 'qa' }));
    } catch (error: any) {
      console.error('Error analyzing specification:', error);
      addMessage('system', `Erreur lors de l'analyse: ${error.message || 'Erreur inconnue'}`);
    } finally {
      setIsLoading(false);
    }
  };

  const sendMessage = async () => {
    if (!input.trim() || isLoading) return;

    const userMessage = input.trim();
    setInput('');
    addMessage('user', userMessage);
    setIsLoading(true);

    try {
      // Préparer l'historique de conversation
      const messages = [
        {
          role: 'system' as const,
          content: `Tu es un assistant de développement expert. Aide l'utilisateur à clarifier ses besoins et génère du code de haute qualité.

Contexte: ${session.specification ? 'Spécification fournie' : 'Pas de spécification'}
Phase actuelle: ${session.phase}

Quand tu génères du code, assure-toi TOUJOURS de :
- Inclure des commentaires détaillés en français dans le code
- Générer un fichier README.md complet avec instructions
- Expliquer la logique et les décisions techniques`,
        },
        ...session.messages.map(m => ({
          role: m.role as 'user' | 'assistant' | 'system',
          content: m.content,
        })),
        { role: 'user' as const, content: userMessage },
      ];

      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          messages,
          model: selectedModel,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        // Afficher le message d'erreur du serveur
        const errorMessage = data.error || `HTTP error! status: ${response.status}`;
        const errorDetails = data.details || '';
        throw new Error(`${errorMessage}\n${errorDetails}`);
      }

      // Vérifier que data.content existe
      if (!data.content) {
        throw new Error('No content in response');
      }

      addMessage('assistant', data.content);

      // Détection automatique de code dans la réponse (avec vérification)
      if (data.content && typeof data.content === 'string' && data.content.includes('```') && session.phase === 'qa') {
        setSession(prev => ({ ...prev, phase: 'generation' }));
      }
    } catch (error: any) {
      console.error('Error sending message:', error);
      addMessage('system', `Erreur lors de l'envoi du message: ${error.message || 'Erreur inconnue'}`);
    } finally {
      setIsLoading(false);
    }
  };

  const generateCode = async () => {
    if (session.phase !== 'generation') {
      alert('Veuillez d\'abord clarifier les besoins en discutant avec l\'agent.');
      return;
    }

    setIsLoading(true);

    const codePrompt = `Basé sur notre conversation et la spécification fournie, génère le code complet et prêt à l'emploi.

IMPORTANT : Tu DOIS générer les fichiers suivants:

📁 **FICHIERS DE CODE SOURCE** avec :
- Commentaires détaillés en français pour CHAQUE fonction/classe/composant
- Commentaires JSDoc, docstrings ou équivalent selon le langage
- Commentaires explicatifs pour toute logique complexe
- Headers de fichier avec description, auteur, date
- Gestion d'erreurs complète avec messages clairs

📄 **README.md** (OBLIGATOIRE) contenant :
- Titre et description du projet
- Architecture et structure des fichiers
- Prérequis système et dépendances
- Instructions d'installation pas à pas
- Guide d'utilisation avec exemples concrets
- Commandes pour lancer/tester le projet
- Variables d'environnement si nécessaire
- Problèmes connus et solutions

📚 **DOCUMENTATION.md** (pour projets complexes) avec :
- Architecture technique détaillée
- Diagrammes (format texte/ASCII ou Mermaid)
- Choix de conception et justifications
- Documentation API si applicable
- Guide de contribution
- Explication des patterns utilisés

⚙️ **Fichiers de configuration** si nécessaire :
- package.json, requirements.txt, etc.
- .env.example avec description des variables
- Fichiers de configuration (nginx, docker, etc.)

STRUCTURE DE TA RÉPONSE :
Pour chaque fichier, utilise ce format :
**nom_du_fichier.ext**
\`\`\`langage
[code ici]
\`\`\`

Génère du code production-ready, propre, sécurisé et maintenable.`;

    try {
      addMessage('user', codePrompt);
      
      const messages = [
        {
          role: 'system' as const,
          content: `Tu es un développeur expert senior. Génère du code de qualité professionnelle avec :
- Code propre et maintenable suivant les best practices
- Commentaires détaillés en français dans TOUS les fichiers
- Documentation complète (README.md OBLIGATOIRE + DOCUMENTATION.md si projet complexe)
- Gestion d'erreurs robuste
- Nommage clair et explicite des variables/fonctions
- Structure de fichiers logique et organisée
Tu ne génères JAMAIS de code sans commentaires ni documentation.`,
        },
        ...session.messages.map(m => ({
          role: m.role as 'user' | 'assistant' | 'system',
          content: m.content,
        })),
        { role: 'user' as const, content: codePrompt },
      ];

      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          messages,
          model: selectedModel,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        // Afficher le message d'erreur du serveur
        const errorMessage = data.error || `HTTP error! status: ${response.status}`;
        const errorDetails = data.details || '';
        throw new Error(`${errorMessage}\n${errorDetails}`);
      }

      if (!data.content) {
        throw new Error('No content in response');
      }

      addMessage('assistant', data.content);

      // Extraire et sauvegarder les blocs de code
      await extractAndSaveCode(data.content);
      
      setSession(prev => ({ ...prev, phase: 'complete' }));
    } catch (error: any) {
      console.error('Error generating code:', error);
      addMessage('system', `Erreur lors de la génération: ${error.message || 'Erreur inconnue'}`);
    } finally {
      setIsLoading(false);
    }
  };

  const extractAndSaveCode = async (content: string) => {
    // Vérifier que content existe et est une string
    if (!content || typeof content !== 'string') {
      console.error('Invalid content for code extraction');
      return;
    }

    // Créer le répertoire de session (une seule fois pour tous les fichiers)
    const sessionDir = `session_${Date.now()}`;

    // Expression régulière pour extraire les blocs de code
    const codeBlockRegex = /```(\w+)?\n([\s\S]*?)```/g;
    let match;
    let fileIndex = 0;

    while ((match = codeBlockRegex.exec(content)) !== null) {
      const language = match[1] || 'txt';
      const code = match[2];

      // Extraire le nom de fichier si mentionné avant le bloc
      const beforeBlock = content.substring(0, match.index);

      // Chercher le nom de fichier dans différents formats
      let filename: string | null = null;

      // 1. Chercher en gras avec ** (ex: **README.md** ou **app.py**)
      const boldMatch = beforeBlock.match(/\*\*([a-zA-Z0-9_\-\.]+\.[a-z]{2,4})\*\*/i);
      if (boldMatch) {
        filename = boldMatch[1];
      }

      // 2. Chercher dans des backticks (ex: `index.html`)
      if (!filename) {
        const backtickMatch = beforeBlock.match(/`([a-zA-Z0-9_\-\.]+\.[a-z]{2,4})`/i);
        if (backtickMatch) {
          filename = backtickMatch[1];
        }
      }

      // 3. Chercher après "fichier:" ou "file:" (ex: "fichier: index.html")
      if (!filename) {
        const fileMatch = beforeBlock.match(/(?:fichier|file|filename)[\s:]+([a-zA-Z0-9_\-\.]+\.[a-z]{2,4})/i);
        if (fileMatch) {
          filename = fileMatch[1];
        }
      }

      // 4. Chercher un nom de fichier valide proche du bloc (dans les 200 derniers caractères)
      if (!filename) {
        const nearBlock = beforeBlock.slice(-200);
        const filenamePatternMatch = nearBlock.match(/([a-zA-Z0-9_\-]+\.[a-z]{2,4})/i);
        if (filenamePatternMatch) {
          filename = filenamePatternMatch[1];
        }
      }

      // 5. Nom par défaut si aucun nom trouvé
      if (!filename) {
        const extensions: Record<string, string> = {
          'javascript': 'js',
          'typescript': 'ts',
          'python': 'py',
          'html': 'html',
          'css': 'css',
          'json': 'json',
          'jsx': 'jsx',
          'tsx': 'tsx',
        };
        const ext = extensions[language.toLowerCase()] || language || 'txt';
        filename = `generated_${fileIndex}.${ext}`;
      }

      // Nettoyer le nom de fichier (supprimer les caractères invalides)
      filename = filename.replace(/[^a-zA-Z0-9_\-\.]/g, '_');

      // Limiter la longueur du nom de fichier
      if (filename.length > 100) {
        const ext = filename.split('.').pop() || 'txt';
        filename = `file_${fileIndex}.${ext}`;
      }

      try {
        const response = await fetch('/api/generate-code', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            code,
            filename,
            directory: sessionDir,
          }),
        });

        const data = await response.json();

        if (data.success) {
          setSession(prev => ({
            ...prev,
            sessionDirectory: sessionDir,
            generatedFiles: [
              ...prev.generatedFiles,
              { name: filename, path: data.path },
            ],
          }));
        } else if (data.error) {
          console.error('Error from generate-code API:', data.error);
          addMessage('system', `Erreur lors de la sauvegarde de ${filename}: ${data.error}`);
        }
      } catch (error: any) {
        console.error('Error saving code file:', error);
        addMessage('system', `Erreur lors de la sauvegarde du fichier: ${error.message}`);
      }

      fileIndex++;
    }
  };

  const addMessage = (role: 'user' | 'assistant' | 'system', content: string) => {
    setSession(prev => ({
      ...prev,
      messages: [
        ...prev.messages,
        { role, content, timestamp: new Date() },
      ],
    }));
  };

  /**
   * Télécharge un fichier individuel
   */
  const downloadFile = async (filename: string, filepath: string) => {
    try {
      const response = await fetch(`/api/download?file=${encodeURIComponent(filepath)}`);

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Erreur lors du téléchargement');
      }

      // Créer un blob et déclencher le téléchargement
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (error: any) {
      console.error('Erreur lors du téléchargement:', error);
      addMessage('system', `Erreur lors du téléchargement de ${filename}: ${error.message}`);
    }
  };

  /**
   * Télécharge tous les fichiers générés en ZIP
   */
  const downloadAllAsZip = async () => {
    if (!session.sessionDirectory) {
      addMessage('system', 'Aucun fichier à télécharger');
      return;
    }

    try {
      const response = await fetch('/api/download-zip', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          sessionDirectory: session.sessionDirectory,
          projectName: 'code-genere',
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Erreur lors de la création du ZIP');
      }

      // Créer un blob et déclencher le téléchargement
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `code-genere-${new Date().toISOString().slice(0, 10)}.zip`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (error: any) {
      console.error('Erreur lors du téléchargement du ZIP:', error);
      addMessage('system', `Erreur lors du téléchargement du ZIP: ${error.message}`);
    }
  };

  const resetSession = () => {
    setSession({
      phase: 'upload',
      messages: [],
      generatedFiles: [],
    });
  };

  return (
    <div className="container mx-auto py-8 max-w-7xl">
      <div className="mb-8">
        <h1 className="text-4xl font-bold mb-2">Agent IA de Développement</h1>
        <p className="text-muted-foreground">
          Uploadez votre spécification, discutez avec l'agent, et générez du code automatiquement
        </p>
        
        {/* Statut de connexion Ollama */}
        <div className="mt-4 flex items-center gap-2">
          {isConnected === null ? (
            <div className="flex items-center gap-2 text-muted-foreground">
              <Loader2 className="h-4 w-4 animate-spin" />
              <span>Vérification de la connexion Ollama...</span>
            </div>
          ) : isConnected ? (
            <div className="flex items-center gap-2 text-green-600">
              <CheckCircle className="h-4 w-4" />
              <span>Connecté à Ollama</span>
              {availableModels.length > 0 && (
                <select
                  value={selectedModel}
                  onChange={(e) => setSelectedModel(e.target.value)}
                  className="ml-4 px-2 py-1 border rounded text-sm"
                >
                  {availableModels.map(model => (
                    <option key={model} value={model}>{model}</option>
                  ))}
                </select>
              )}
            </div>
          ) : (
            <div className="flex items-center gap-2 text-red-600">
              <AlertCircle className="h-4 w-4" />
              <span>Ollama non accessible. Assurez-vous qu'Ollama est démarré (http://localhost:11434)</span>
            </div>
          )}
        </div>
      </div>

      <Tabs defaultValue="chat" className="space-y-4">
        <TabsList>
          <TabsTrigger value="chat">Chat</TabsTrigger>
          <TabsTrigger value="files">Fichiers générés ({session.generatedFiles.length})</TabsTrigger>
        </TabsList>

        <TabsContent value="chat" className="space-y-4">
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
            {/* Zone de chat principale */}
            <Card className="lg:col-span-2">
              <CardHeader>
                <CardTitle>Conversation</CardTitle>
                <CardDescription>
                  Phase: <span className="font-semibold capitalize">{session.phase}</span>
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                {/* Messages */}
                <ScrollArea className="h-[500px] pr-4" ref={scrollRef}>
                  <div className="space-y-4">
                    {session.messages.map((message, index) => (
                      <div
                        key={index}
                        className={`flex ${
                          message.role === 'user' ? 'justify-end' : 'justify-start'
                        }`}
                      >
                        <div
                          className={`max-w-[80%] rounded-lg p-4 ${
                            message.role === 'user'
                              ? 'bg-primary text-primary-foreground'
                              : message.role === 'system'
                              ? 'bg-yellow-100 text-yellow-900 dark:bg-yellow-900 dark:text-yellow-100'
                              : 'bg-muted'
                          }`}
                        >
                          <div className="text-sm font-semibold mb-1 capitalize">
                            {message.role}
                          </div>
                          <div className="whitespace-pre-wrap break-words">
                            {message.content}
                          </div>
                          <div className="text-xs opacity-70 mt-2">
                            {message.timestamp.toLocaleTimeString()}
                          </div>
                        </div>
                      </div>
                    ))}
                    {isLoading && (
                      <div className="flex justify-start">
                        <div className="bg-muted rounded-lg p-4">
                          <Loader2 className="h-4 w-4 animate-spin" />
                        </div>
                      </div>
                    )}
                  </div>
                </ScrollArea>

                {/* Zone de saisie */}
                <div className="flex gap-2">
                  <Textarea
                    placeholder={
                      session.phase === 'upload'
                        ? 'Uploadez d\'abord une spécification...'
                        : 'Tapez votre message...'
                    }
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter' && !e.shiftKey) {
                        e.preventDefault();
                        sendMessage();
                      }
                    }}
                    disabled={session.phase === 'upload' || isLoading || !isConnected}
                    className="flex-1"
                  />
                  <Button
                    onClick={sendMessage}
                    disabled={!input.trim() || isLoading || session.phase === 'upload' || !isConnected}
                    size="icon"
                  >
                    <Send className="h-4 w-4" />
                  </Button>
                </div>
              </CardContent>
            </Card>

            {/* Panneau latéral d'actions */}
            <div className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle>Actions</CardTitle>
                </CardHeader>
                <CardContent className="space-y-3">
                  {session.phase === 'upload' && (
                    <>
                      <input
                        type="file"
                        ref={fileInputRef}
                        onChange={handleFileUpload}
                        accept=".txt,.md,.pdf"
                        className="hidden"
                      />
                      <Button
                        onClick={() => fileInputRef.current?.click()}
                        className="w-full"
                        disabled={!isConnected}
                      >
                        <FileText className="mr-2 h-4 w-4" />
                        Upload Spécification
                      </Button>
                    </>
                  )}

                  {(session.phase === 'qa' || session.phase === 'generation') && (
                    <Button
                      onClick={generateCode}
                      className="w-full"
                      disabled={isLoading || !isConnected}
                    >
                      <Code className="mr-2 h-4 w-4" />
                      Générer le Code
                    </Button>
                  )}

                  <Button
                    onClick={resetSession}
                    variant="outline"
                    className="w-full"
                  >
                    Nouvelle Session
                  </Button>
                </CardContent>
              </Card>

              {session.specification && (
                <Card>
                  <CardHeader>
                    <CardTitle>Spécification</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <ScrollArea className="h-[200px]">
                      <pre className="text-xs whitespace-pre-wrap">
                        {session.specification.substring(0, 500)}...
                      </pre>
                    </ScrollArea>
                  </CardContent>
                </Card>
              )}
            </div>
          </div>
        </TabsContent>

        <TabsContent value="files">
          <Card>
            <CardHeader>
              <div className="flex items-center justify-between">
                <div>
                  <CardTitle>Fichiers Générés</CardTitle>
                  <CardDescription>
                    Les fichiers de code générés par l'agent
                  </CardDescription>
                </div>
                {session.generatedFiles.length > 0 && (
                  <Button
                    onClick={downloadAllAsZip}
                    variant="default"
                    size="sm"
                    className="gap-2"
                  >
                    <Archive className="h-4 w-4" />
                    Télécharger tout en ZIP
                  </Button>
                )}
              </div>
            </CardHeader>
            <CardContent>
              {session.generatedFiles.length === 0 ? (
                <p className="text-muted-foreground text-center py-8">
                  Aucun fichier généré pour le moment
                </p>
              ) : (
                <div className="space-y-2">
                  {session.generatedFiles.map((file, index) => (
                    <div
                      key={index}
                      className="flex items-center justify-between p-3 border rounded-lg"
                    >
                      <div className="flex items-center gap-3">
                        <Code className="h-5 w-5 text-muted-foreground" />
                        <div>
                          <div className="font-medium">{file.name}</div>
                          <div className="text-xs text-muted-foreground">
                            {file.path}
                          </div>
                        </div>
                      </div>
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => downloadFile(file.name, file.path)}
                        title={`Télécharger ${file.name}`}
                      >
                        <Download className="h-4 w-4" />
                      </Button>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
