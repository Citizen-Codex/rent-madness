<script lang="ts">
	let {
		children,
		bordered = false,
		borderTop = bordered,
		borderBottom = bordered,
		class: classes = ''
	} = $props();
</script>

<section
	class={[
		'border-gray relative flex flex-col gap-16 bg-white py-16',
		borderTop && 'border-t',
		borderBottom && 'border-b',
		classes
	]}
>
	{@render children?.()}
</section>
