/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  experimental: {
    serverActions: {
      bodySizeLimit: '10mb',
    },
  },
  // Transpiler les modules si nécessaire
  transpilePackages: [],
  // Configurer les domaines d'images si utilisés
  images: {
    domains: [],
  },
}

module.exports = nextConfig
