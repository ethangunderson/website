// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require("tailwindcss/plugin");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./js/**/*.js", "./lib/**/*.ex"],
  theme: {
    extend: {
      colors: {
        "site-bg": "#f5f5f0",
        "sidebar-bg": "#ffffff",
        ink: "#111111",
        accent: "#e63000",
        "accent-blue": "#0047ff",
        muted: "#888888",
      },
      fontFamily: {
        sans: ['"Inter"', ...defaultTheme.fontFamily.sans],
      },
      gridTemplateColumns: {
        layout: "280px 1fr",
      },
      typography: {
        DEFAULT: {
          css: {
            "--tw-prose-body": "#111111",
            "--tw-prose-headings": "#111111",
            "--tw-prose-links": "#111111",
            "--tw-prose-bold": "#111111",
            "--tw-prose-counters": "#888888",
            "--tw-prose-bullets": "#111111",
            "--tw-prose-hr": "#111111",
            "--tw-prose-quotes": "#111111",
            "--tw-prose-quote-borders": "#e63000",
            "--tw-prose-code": "#111111",
            "--tw-prose-pre-bg": "#1a1a1a",
            "--tw-prose-pre-code": "#f5f5f0",
            maxWidth: "none",
            a: {
              color: "#111111",
              textDecoration: "underline",
              textDecorationColor: "#111111",
              textUnderlineOffset: "3px",
              transition: "color 80ms, text-decoration-color 80ms",
              "&:hover": {
                color: "#e63000",
                textDecorationColor: "#e63000",
              },
            },
            "h1, h2, h3, h4": {
              fontWeight: "800",
              textTransform: "uppercase",
              letterSpacing: "-0.02em",
            },
            blockquote: {
              borderLeftColor: "#e63000",
              borderLeftWidth: "4px",
              fontStyle: "normal",
              fontWeight: "500",
            },
            code: {
              backgroundColor: "#e8e8e3",
              padding: "0.1em 0.3em",
              fontSize: "0.9em",
              borderRadius: "0",
            },
            "code::before": { content: '""' },
            "code::after": { content: '""' },
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
