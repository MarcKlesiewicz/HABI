/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './apps/**/*.{js,ts,jsx,tsx,html}',
    './libs/**/*.{js,ts,jsx,tsx,html}',
  ],
  theme: {
    extend: {
      sans: ['Outfit', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      colors: {
        primary: {
          50: '#ffeaea',
          100: '#ffd6d7',
          200: '#ffb3b5',
          300: '#ff9093',
          400: '#ff6d71',
          500: '#ff9b9d',
          600: '#e27577',
          700: '#b95c5e',
          800: '#8f4446',
          900: '#662c2e',
        },
      },
    },
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: [
      {
        mytheme: {
          primary: '#ff9b9d',
          'primary-focus': '#e27577',
          'primary-content': '#ffffff',

          secondary: '#f2b33f',
          'secondary-focus': '#d29c2e',
          'secondary-content': '#ffffff',

          accent: '#00917A',
          'accent-focus': '#00725f',
          'accent-content': '#ffffff',

          neutral: '#27272a',
          'neutral-focus': '#18181b',
          'neutral-content': '#ffffff',

          'base-100': '#3b424e',
          'base-200': '#2a2e37',
          'base-300': '#16181d',
          'base-content': '#ebecf0',

          info: '#66c7ff',
          success: '#87cf3a',
          warning: '#e1d460',
          error: '#ff6b6b',
        },
      },
    ],
  },
};
