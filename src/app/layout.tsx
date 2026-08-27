import type { Metadata, Viewport } from "next";
import type { ReactNode } from "react";

import "./globals.css";

export const metadata: Metadata = {
  metadataBase: new URL("http://localhost:3000"),
  title: {
    default: "Cookie Court",
    template: "%s | Cookie Court",
  },
  description:
    "Import browser cookie exports, turn trackers into mock defendants, run a one-minute jury simulation, and export a consent report.",
  applicationName: "Cookie Court",
};

export const viewport: Viewport = {
  themeColor: "#0f172a",
  width: "device-width",
  initialScale: 1,
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>
        <main className="app-main">{children}</main>
      </body>
    </html>
  );
}