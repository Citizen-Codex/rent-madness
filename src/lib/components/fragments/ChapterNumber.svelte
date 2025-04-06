<script lang="ts">
	const { children } = $props();
</script>

<div
	class="flex h-12 w-12 items-center justify-center rounded-full border font-serif text-xl font-bold text-black md:h-16 md:w-16 md:text-2xl"
>
	{@render children?.()}
</div>
