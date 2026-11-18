export interface BlogPost {
  slug: string;
  title: string;
  description: string;
  category: string;
}

export const blogPosts: BlogPost[] = [
  {
    slug: "knife-care-and-maintenance",
    title: "How to Care for Your Knives at Home",
    description:
      "Simple habits for honing, washing, storing, and using your knives so their edges last longer between professional sharpenings.",
    category: "Knife care",
  },
  {
    slug: "knife-safety",
    title: "The Golden Rules for a Safer Kitchen",
    description:
      "Why a well-maintained edge requires less force, plus practical habits for safer, more controlled cutting.",
    category: "Kitchen safety",
  },
];
