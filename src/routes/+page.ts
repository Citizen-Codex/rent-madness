import page from './+page.yaml';

export const prerender = true;

export const load = () => {
  return {
    ...page,
  };
};
