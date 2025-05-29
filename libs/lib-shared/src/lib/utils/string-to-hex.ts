export function stringToHex(str: string): string {
  // Ensure the string has exactly 2 characters
  if (str.length !== 2) throw new Error('Input must be exactly two letters');

  // Convert each character to its char code and combine them
  const code1 = str.charCodeAt(0);
  const code2 = str.charCodeAt(1);

  // Simple hash: mix the char codes and map to RGB
  const r = (code1 * 70 + code2 * 17) % 256;
  const g = (code1 * 13 + code2 * 97) % 256;
  const b = (code1 * 23 + code2 * 53) % 256;

  // Convert to hex and pad with zeros if needed
  const hex = (n: number) => n.toString(16).padStart(2, '0');
  return `#${hex(r)}${hex(g)}${hex(b)}`;
}
