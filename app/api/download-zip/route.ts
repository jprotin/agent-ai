/**
 * API Route pour télécharger tous les fichiers générés en ZIP
 * Crée une archive ZIP de tous les fichiers d'une session
 *
 * @author Agent IA de Développement
 * @date 2025-12-03
 */

import { NextRequest, NextResponse } from 'next/server';
import archiver from 'archiver';
import fs from 'fs';
import path from 'path';
import { Readable } from 'stream';

/**
 * POST /api/download-zip
 * Body: { sessionDirectory: string, projectName?: string }
 * Crée et télécharge un fichier ZIP contenant tous les fichiers d'une session
 */
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { sessionDirectory, projectName } = body;

    // Validation du répertoire de session
    if (!sessionDirectory) {
      return NextResponse.json(
        { error: 'Paramètre "sessionDirectory" manquant' },
        { status: 400 }
      );
    }

    // Construire le chemin absolu du répertoire
    const outputDir = path.join(process.cwd(), 'output');
    const sessionPath = path.join(outputDir, sessionDirectory);

    // Vérifier que le répertoire existe
    if (!fs.existsSync(sessionPath)) {
      return NextResponse.json(
        { error: 'Répertoire de session non trouvé' },
        { status: 404 }
      );
    }

    // Vérifier que le chemin est bien dans output (sécurité)
    if (!sessionPath.startsWith(outputDir)) {
      return NextResponse.json(
        { error: 'Accès non autorisé au répertoire' },
        { status: 403 }
      );
    }

    // Créer le nom du fichier ZIP
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, -5);
    const zipName = projectName
      ? `${projectName.replace(/[^a-zA-Z0-9\-_]/g, '_')}-${timestamp}.zip`
      : `project-${timestamp}.zip`;

    // Créer l'archive ZIP
    const archive = archiver('zip', {
      zlib: { level: 9 } // Niveau de compression maximum
    });

    // Gérer les erreurs de l'archive
    archive.on('error', (err) => {
      console.error('Erreur lors de la création du ZIP:', err);
      throw err;
    });

    // Ajouter tous les fichiers du répertoire de session à l'archive
    archive.directory(sessionPath, false);

    // Finaliser l'archive
    await archive.finalize();

    // Convertir le stream en buffer
    const chunks: Buffer[] = [];
    for await (const chunk of archive) {
      chunks.push(Buffer.from(chunk));
    }
    const zipBuffer = Buffer.concat(chunks);

    // Retourner le fichier ZIP
    return new NextResponse(zipBuffer, {
      status: 200,
      headers: {
        'Content-Type': 'application/zip',
        'Content-Disposition': `attachment; filename="${zipName}"`,
        'Content-Length': zipBuffer.length.toString(),
      },
    });
  } catch (error: any) {
    console.error('Erreur lors de la création du ZIP:', error);
    return NextResponse.json(
      {
        error: 'Erreur lors de la création du fichier ZIP',
        details: error.message
      },
      { status: 500 }
    );
  }
}

/**
 * GET /api/download-zip?directory=<path>&projectName=<name>
 * Alternative GET endpoint pour télécharger un ZIP
 */
export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const sessionDirectory = searchParams.get('directory');
    const projectName = searchParams.get('projectName') || undefined;

    // Validation
    if (!sessionDirectory) {
      return NextResponse.json(
        { error: 'Paramètre "directory" manquant' },
        { status: 400 }
      );
    }

    // Construire le chemin absolu du répertoire
    const outputDir = path.join(process.cwd(), 'output');
    const sessionPath = path.join(outputDir, sessionDirectory);

    // Vérifier que le répertoire existe
    if (!fs.existsSync(sessionPath)) {
      return NextResponse.json(
        { error: 'Répertoire de session non trouvé' },
        { status: 404 }
      );
    }

    // Vérifier que le chemin est bien dans output (sécurité)
    if (!sessionPath.startsWith(outputDir)) {
      return NextResponse.json(
        { error: 'Accès non autorisé au répertoire' },
        { status: 403 }
      );
    }

    // Créer le nom du fichier ZIP
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, -5);
    const zipName = projectName
      ? `${projectName.replace(/[^a-zA-Z0-9\-_]/g, '_')}-${timestamp}.zip`
      : `project-${timestamp}.zip`;

    // Créer l'archive ZIP
    const archive = archiver('zip', {
      zlib: { level: 9 }
    });

    // Gérer les erreurs
    archive.on('error', (err) => {
      console.error('Erreur lors de la création du ZIP:', err);
      throw err;
    });

    // Ajouter tous les fichiers
    archive.directory(sessionPath, false);

    // Finaliser
    await archive.finalize();

    // Convertir en buffer
    const chunks: Buffer[] = [];
    for await (const chunk of archive) {
      chunks.push(Buffer.from(chunk));
    }
    const zipBuffer = Buffer.concat(chunks);

    // Retourner le ZIP
    return new NextResponse(zipBuffer, {
      status: 200,
      headers: {
        'Content-Type': 'application/zip',
        'Content-Disposition': `attachment; filename="${zipName}"`,
        'Content-Length': zipBuffer.length.toString(),
      },
    });
  } catch (error: any) {
    console.error('Erreur lors de la création du ZIP:', error);
    return NextResponse.json(
      {
        error: 'Erreur lors de la création du fichier ZIP',
        details: error.message
      },
      { status: 500 }
    );
  }
}
