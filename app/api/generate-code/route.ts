import { NextRequest, NextResponse } from 'next/server';
import fs from 'fs/promises';
import path from 'path';

export const runtime = 'nodejs';

interface GenerateCodeRequest {
  code: string;
  filename: string;
  directory?: string;
}

export async function POST(req: NextRequest) {
  try {
    const { code, filename, directory = 'generated-code' }: GenerateCodeRequest = await req.json();

    if (!code || !filename) {
      return NextResponse.json(
        { error: 'Code and filename are required' },
        { status: 400 }
      );
    }

    // Créer le répertoire de base dans le home de l'utilisateur
    const baseDir = path.join(process.cwd(), 'output', directory);
    
    try {
      await fs.mkdir(baseDir, { recursive: true });
    } catch (error) {
      console.error('Error creating directory:', error);
    }

    // Créer le fichier avec le code généré
    const filePath = path.join(baseDir, filename);
    await fs.writeFile(filePath, code, 'utf-8');

    return NextResponse.json({
      success: true,
      path: filePath,
      message: `Code generated successfully at ${filePath}`,
    });

  } catch (error: any) {
    console.error('Generate code API error:', error);
    return NextResponse.json(
      { error: error.message || 'Failed to generate code' },
      { status: 500 }
    );
  }
}

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const directory = searchParams.get('directory') || 'generated-code';

    const baseDir = path.join(process.cwd(), 'output', directory);
    
    try {
      const files = await fs.readdir(baseDir);
      
      const filesList = await Promise.all(
        files.map(async (file) => {
          const filePath = path.join(baseDir, file);
          const stats = await fs.stat(filePath);
          
          return {
            name: file,
            path: filePath,
            size: stats.size,
            created: stats.birthtime,
            modified: stats.mtime,
            isDirectory: stats.isDirectory(),
          };
        })
      );

      return NextResponse.json({ files: filesList });
    } catch (error) {
      // Le répertoire n'existe pas encore
      return NextResponse.json({ files: [] });
    }

  } catch (error: any) {
    console.error('List files API error:', error);
    return NextResponse.json(
      { error: error.message || 'Failed to list files' },
      { status: 500 }
    );
  }
}
