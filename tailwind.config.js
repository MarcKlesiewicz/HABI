/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './apps/**/*.{js,ts,jsx,tsx,html}',
    './libs/**/*.{js,ts,jsx,tsx,html}',
  ],
  theme: {
    extend: {
      sans: ['Outfit', 'ui-sans-serif', 'system-ui', 'sans-serif'],
    },
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: [
      {
        mytheme: {
          primary: '#3b82f6',

          secondary: '#fbbf24',
          accent: '#4ade80',
          neutral: '#ffffff',
          'base-100': '#ffffff',
          info: '#3abff8',
          success: '#36d399',
          warning: '#fbbd23',
          error: '#f87272',
          dark: '#17171c',
        },
      },
    ],
  },
};
