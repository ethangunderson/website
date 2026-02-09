// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require("tailwindcss/plugin");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./js/**/*.js", "./lib/**/*.ex"],
  theme: {
    extend: {
      colors: {
        walnut: "#1a1612",
        surface: "#2a2420",
        parchment: "#e8ddd0",
        amber: "#d4883a",
        copper: "#b87333",
        grain: "#3d352e",
        grille: "#8a7e72",
      },
      fontFamily: {
        heading: ['"Space Grotesk"', ...defaultTheme.fontFamily.sans],
        body: ['"Source Serif 4"', ...defaultTheme.fontFamily.serif],
      },
      typography: {
        DEFAULT: {
          css: {
            "--tw-prose-body": "#e8ddd0",
            "--tw-prose-headings": "#e8ddd0",
            "--tw-prose-links": "#d4883a",
            "--tw-prose-bold": "#e8ddd0",
            "--tw-prose-counters": "#d4883a",
            "--tw-prose-bullets": "#3d352e",
            "--tw-prose-hr": "#3d352e",
            "--tw-prose-quotes": "#e8ddd0",
            "--tw-prose-quote-borders": "#d4883a",
            "--tw-prose-code": "#e8ddd0",
            "--tw-prose-pre-bg": "#2a2420",
            "--tw-prose-pre-code": "#e8ddd0",
            a: {
              color: "#d4883a",
              textDecoration: "underline",
              textDecorationColor: "#3d352e",
              textUnderlineOffset: "3px",
              transition: "all 150ms ease",
              "&:hover": {
                color: "#b87333",
                textDecorationColor: "#b87333",
                textShadow: "0 0 8px rgba(212, 136, 58, 0.3)",
              },
            },
            h1: {
              fontFamily: '"Space Grotesk", sans-serif',
            },
            h2: {
              fontFamily: '"Space Grotesk", sans-serif',
            },
            h3: {
              fontFamily: '"Space Grotesk", sans-serif',
            },
          },
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/container-queries"),
  ],
};
