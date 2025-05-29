export function getInitials(fullName: string): string {
  if (!fullName) return '';
  const parts = fullName.trim().split(/\s+/);
  if (parts.length === 1) {
    return parts[0][0].toUpperCase();
  }
  // First letter of first and last word
  return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}
