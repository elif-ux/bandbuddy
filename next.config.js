/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // Docker için standalone output (opsiyonel)
  output: process.env.DOCKER === 'true' ? 'standalone' : (process.env.STATIC_EXPORT === 'true' ? 'export' : undefined),
}

module.exports = nextConfig

