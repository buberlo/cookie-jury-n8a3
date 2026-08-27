/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,

  // Keep the native better-sqlite3 binding out of the server bundle.
  webpack: (config, { isServer }) => {
    if (isServer) {
      config.externals.push({
        'better-sqlite3': 'commonjs better-sqlite3',
      });
    }

    return config;
  },
};

export default nextConfig;