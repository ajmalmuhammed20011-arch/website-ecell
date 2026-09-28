import { events } from '../data/events';
import { teamMembers } from '../data/teamMembers';
import { supabase } from './supabase';
export async function getTeamMembers() {
  if (!supabase) return teamMembers;
  const { data, error } = await supabase.from('team_members').select('*').order('sort_order');
  return error || !data?.length ? teamMembers : data.map(row => ({ id: row.id, name: row.name, position: row.position, team: row.team, image: row.image_url || '', instagram: row.instagram || undefined, linkedin: row.linkedin || undefined, bio: row.bio || undefined }));
}
export async function getEvents() {
  if (!supabase) return events;
  const { data, error } = await supabase.from('events').select('*').order('date', { ascending: false });
  return error || !data?.length ? events : data.map(row => ({ ...row, coverImage: row.cover_image, photos: row.photos || [], highlights: row.highlights || [] }));
}
