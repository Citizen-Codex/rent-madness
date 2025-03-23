<script lang="ts">
	interface Props {
		icon: string;
		class?: string | string[];
		size?: 'sm' | 'md' | 'lg';
	}

	const { icon, class: classes, size = 'lg', ...rest }: Props = $props();
</script>

<iconify-icon
	{icon}
	class={[
		'flex items-center justify-center rounded-full',
		classes,
		{ 'h-12 w-12': size === 'lg' },
		{ 'h-10 w-10': size === 'md' },
		{ 'h-8 w-8': size === 'sm' }
	]}
	{...rest}
></iconify-icon>
