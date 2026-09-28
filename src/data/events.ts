export interface EventItem { title: string; slug: string; date: string; venue: string; category: string; description: string; speaker?: string; status: 'upcoming' | 'completed'; coverImage?: string; photos: string[]; highlights: string[] }
// Add verified event records here as event history and photos are provided.
export const events: EventItem[] = [];
