/**
 * API Route pour télécharger les fichiers générés individuellement
 * Permet de servir les fichiers créés par le LLM
 *
 * @author Agent IA de Développement
 * @date 2025-12-03
 */

import { NextRequest, NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';

/**
 * GET /api/download?file=<path>
 * Télécharge un fichier généré individuel
 */
export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const filePath = searchParams.get('file');

    // Validation du paramètre file
    if (!filePath) {
      return NextResponse.json(
        { error: 'Paramètre "file" manquant' },
        { status: 400 }
      );
    }

    // Sécurité : empêcher l'accès à des fichiers en dehors du répertoire output
    const outputDir = path.join(process.cwd(), 'output');
    const absoluteFilePath = path.join(process.cwd(), filePath);

    // Vérifier que le fichier est bien dans le répertoire output
    if (!absoluteFilePath.startsWith(outputDir)) {
      return NextResponse.json(
        { error: 'Accès non autorisé au fichier' },
        { status: 403 }
      );
    }

    // Vérifier que le fichier existe
    if (!fs.existsSync(absoluteFilePath)) {
      return NextResponse.json(
        { error: 'Fichier non trouvé' },
        { status: 404 }
      );
    }

    // Lire le fichier
    const fileContent = fs.readFileSync(absoluteFilePath);
    const fileName = path.basename(absoluteFilePath);

    // Déterminer le type MIME en fonction de l'extension
    const ext = path.extname(fileName).toLowerCase();
    const mimeTypes: Record<string, string> = {
      '.js': 'application/javascript',
      '.ts': 'application/typescript',
      '.tsx': 'application/typescript',
      '.jsx': 'application/javascript',
      '.py': 'text/x-python',
      '.html': 'text/html',
      '.css': 'text/css',
      '.json': 'application/json',
      '.md': 'text/markdown',
      '.txt': 'text/plain',
      '.xml': 'application/xml',
      '.yml': 'text/yaml',
      '.yaml': 'text/yaml',
    };

    const mimeType = mimeTypes[ext] || 'application/octet-stream';

    // Retourner le fichier avec les bons headers
    return new NextResponse(fileContent, {
      status: 200,
      headers: {
        'Content-Type': mimeType,
        'Content-Disposition': `attachment; filename="${fileName}"`,
        'Content-Length': fileContent.length.toString(),
      },
    });
  } catch (error: any) {
    console.error('Erreur lors du téléchargement du fichier:', error);
    return NextResponse.json(
      {
        error: 'Erreur lors du téléchargement du fichier',
        details: error.message
      },
      { status: 500 }
    );
  }
}
