<script lang="ts">
	const { children } = $props();
</script>

<div
	class="flex h-16 w-16 items-center justify-center rounded-full border font-serif text-2xl font-bold text-black"
>
	{@render children?.()}
</div>
