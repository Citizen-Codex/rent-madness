// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
declare global {
  namespace App {
    // interface Error {}
    // interface Locals {}
    // interface PageData {}
    // interface PageState {}
    // interface Platform {}
  }

  type MapView = {
    zoom: number;
    center: [number, number];
  } | { bbox: [number, number, number, number] };

  declare module '*.yaml' {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const value: Record<string, any>;
    export default value;
  }

  declare module '*.yml' {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const value: Record<string, any>;
    export default value;
  }
}


export { };
