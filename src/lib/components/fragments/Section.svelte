<script lang="ts">
	let {
		children,
		background = true,
		padding = true,
		bordered = false,
		borderTop = bordered,
		borderBottom = bordered,
		class: classes = ''
	} = $props();
</script>

<section
	class={[
		'border-gray relative flex flex-col gap-16',
		padding && 'py-16',
		background && 'bg-white',
		borderTop && 'border-t',
		borderBottom && 'border-b',
		classes
	]}
>
	{@render children?.()}
</section>
