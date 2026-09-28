# E-Cell SBCE website

A responsive React + TypeScript site for the entrepreneurship community at Sree Buddha College of Engineering. It includes the official social links, named team from the supplied brief, responsive pages, reduced-motion handling, a Three.js hero, and Supabase-ready forms and live presence.

## Run locally

1. Install Node.js 20 or newer.
2. In this folder run `npm install` and `npm run dev`.
3. Copy `.env.example` to `.env.local`. Set `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, and `VITE_ADMIN_EMAILS`.
4. In Supabase SQL Editor, run `supabase/schema.sql`.
5. Add each administrator to both the front-end sign-in allowlist and the protected database allowlist: `insert into public.admin_users(email) values ('admin@example.edu') on conflict do nothing;`. Create that user in Supabase Authentication too. The database allowlist enforces access; the Vite variable only controls the admin interface.
6. Never expose a service-role key in the website.

The site runs without Supabase too. In that mode public pages use static data, forms explain that the backend is not configured, and live presence stays unreported rather than inventing a figure.

## Content updates

- **Team:** `src/data/teamMembers.ts` is the static fallback. Add photos under `public/images/team/<team-slug>/<member-id>.jpg`. Missing portraits show branded initials. Optional fields render only when supplied.
- **Events:** add verified records to `src/data/events.ts` using the `EventItem` shape, or insert records into the `events` table. Detail routes use `/events/<slug>`.
- **Gallery:** add confirmed image paths and categories to `src/data/gallery.ts`.
- **Initiatives and opportunities:** edit `src/data/initiatives.ts` and `src/data/opportunities.ts`.
- **Official channels and palette:** `src/data/siteConfig.ts` and CSS custom properties in `src/style.css`.

The team names and roles came from the supplied project brief. Photos, biographies, personal socials, and event history were not included, so the site uses branded placeholders and honest empty states. The official WhatsApp, Instagram, and LinkedIn URLs came from the supplied official-links PDF. No official email address was provided.

## Supabase privacy and deployment

- `members`, `ideas`, and `messages` accept public form inserts with database constraints. RLS blocks public reads, so submissions and emails are not exposed.
- `member_count()` returns only an aggregate count. The site can add a safe count-only Realtime stream later; member rows and emails are never broadcast.
- `site-presence` uses Supabase Realtime Presence when configured.
- Admin sign-in checks authenticated email against `VITE_ADMIN_EMAILS`; database access additionally checks `public.admin_users` through `is_ecell_admin()`. The dashboard supports private member/idea lists and CSV exports plus add/remove for event and team records.
- Forms use Zod and PostgreSQL constraints with a honeypot. Add an edge-function or gateway rate limit before high-volume public launch.
- Create a private `team-photos` Storage bucket and authenticated admin-only upload policies before enabling uploads.
- Run `npm run build` to type-check and produce `dist/`. `vercel.json` includes the SPA rewrite for direct app routes. For Vercel, use this directory as the project root (or `outputs/ecell-sbce` when importing the full parent workspace), with the Vite build command and `dist` output directory.
