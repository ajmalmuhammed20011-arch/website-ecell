export type TeamName = 'Leadership' | 'Program Coordination' | 'Marketing' | 'Design' | 'Documentation';
export interface TeamMember { id: string; name: string; position: string; team: TeamName; image: string; instagram?: string; linkedin?: string; bio?: string; department?: string; year?: string }
export const teamMembers: TeamMember[] = [
  { id: 'adithya-s', name: 'Adithya S', position: 'Chairperson', team: 'Leadership', image: '/images/team/leadership/adithya-s.jpg' },
  { id: 'sreeksh-a', name: 'Sreeksh A', position: 'Vice Chairperson', team: 'Leadership', image: '/images/team/leadership/sreeksh-a.jpg' },
  { id: 'b-mahadev', name: 'B Mahadev', position: 'Program Coordination Lead 1', team: 'Program Coordination', image: '/images/team/program-coordination/b-mahadev.jpg' },
  { id: 'kalyani-m', name: 'Kalyani M', position: 'Program Coordination Lead 2', team: 'Program Coordination', image: '/images/team/program-coordination/kalyani-m.jpg' },
  { id: 'aysha-lina', name: 'Aysha Lina', position: 'Marketing Lead 1', team: 'Marketing', image: '/images/team/marketing/aysha-lina.jpg' },
  { id: 'abhilash-a', name: 'Abhilash A', position: 'Marketing Lead 2', team: 'Marketing', image: '/images/team/marketing/abhilash-a.jpg' },
  { id: 'niranjana', name: 'Niranjana', position: 'Design Lead', team: 'Design', image: '/images/team/design/niranjana.jpg' },
  { id: 'abhinav-ajay', name: 'Abhinav Ajay', position: 'Design Lead 2', team: 'Design', image: '/images/team/design/abhinav-ajay.jpg' },
  { id: 'ajmalmuhammed', name: 'Ajmalmuhammed', position: 'Documentation Lead', team: 'Documentation', image: '/images/team/documentation/ajmalmuhammed.jpg' },
];
