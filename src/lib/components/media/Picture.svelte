<script lang="ts" module>
	const imports = import.meta.glob('../../assets/**/*.{avif,gif,heif,jpeg,jpg,png,tiff,webp}', {
		query: { enhanced: true },
		eager: true,
		import: 'default'
	});

	const pictures = Object.fromEntries(
		Object.entries(imports).map(([key, value]) => {
			return [key.replace('../../assets/', ''), value];
		})
	);
</script>

<script lang="ts">
	interface Props {
		lazy?: boolean;
		src: string;
		alt: string;
		class?: string[] | string;
	}

	let { lazy = true, src, alt, class: classes = '' }: Props = $props();
</script>

<enhanced:img src={pictures[src]} {alt} loading={lazy ? 'lazy' : 'eager'} class={classes} />
