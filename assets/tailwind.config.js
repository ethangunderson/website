// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require("tailwindcss/plugin");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./js/**/*.js", "./lib/**/*.ex"],
  theme: {
    extend: {
      colors: {
        cream: "#faf6f1",
        ink: "#1a1a1a",
        accent: "#20635a",
        "accent-hover": "#2a7f74",
        "border-warm": "#d4cdc4",
        muted: "#7a746b",
      },
      fontFamily: {
        heading: ['"Playfair Display"', ...defaultTheme.fontFamily.serif],
        body: ["Inter", ...defaultTheme.fontFamily.sans],
      },
      typography: {
        DEFAULT: {
          css: {
            "--tw-prose-body": "#1a1a1a",
            "--tw-prose-headings": "#1a1a1a",
            "--tw-prose-links": "#20635a",
            "--tw-prose-bold": "#1a1a1a",
            "--tw-prose-counters": "#20635a",
            "--tw-prose-bullets": "#d4cdc4",
            "--tw-prose-hr": "#d4cdc4",
            "--tw-prose-quotes": "#1a1a1a",
            "--tw-prose-quote-borders": "#20635a",
            "--tw-prose-code": "#1a1a1a",
            "--tw-prose-pre-bg": "#1a1a1a",
            "--tw-prose-pre-code": "#faf6f1",
            hr: "dashed 1px",
            pre: false,
            a: {
              color: "#20635a",
              textDecoration: "underline",
              textDecorationColor: "#d4cdc4",
              textUnderlineOffset: "3px",
              transition: "text-decoration-color 150ms ease",
              "&:hover": {
                textDecorationColor: "#20635a",
              },
            },
            h1: {
              fontFamily: '"Playfair Display", serif',
            },
            h2: {
              fontFamily: '"Playfair Display", serif',
            },
            h3: {
              fontFamily: '"Playfair Display", serif',
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
