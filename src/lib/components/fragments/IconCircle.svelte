<script lang="ts">
	interface Props {
		icon: string;
		class?: string | string[];
		iconClasses?: string | string[];
		size?: 'sm' | 'md' | 'lg';
	}

	const { icon, class: classes, iconClasses, size = 'lg', ...rest }: Props = $props();
</script>

<div
	class={[
		'flex items-center justify-center rounded-full',
		classes,
		{ 'h-12 w-12': size === 'lg' },
		{ 'h-10 w-10': size === 'md' },
		{ 'h-8 w-8': size === 'sm' }
	]}
>
	<iconify-icon {icon} class={iconClasses} {...rest}></iconify-icon>
</div>
