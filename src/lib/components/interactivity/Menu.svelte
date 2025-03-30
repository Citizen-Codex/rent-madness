<script lang="ts">
	import { Popover } from 'bits-ui';
	import { fly } from 'svelte/transition';

	const chapters = [
		{ title: 'Introduction', href: '#introduction' },
		{ title: 'The Real Stakes', href: '#stakes' },
		{ title: 'Explore', href: '#explore' },
		{ title: 'Policy Implications', href: '#implications' },
		{ title: 'Types of Rental Data', href: '#types' },
		{ title: 'Divergence of Rental Data', href: '#divergence' },
		{ title: 'How to Improve', href: '#solutions' },
		{ title: 'Conclusion', href: '#conclusion' }
	];

	let popoverOpen = $state(false);
</script>

<Popover.Root bind:open={popoverOpen}>
	<Popover.Trigger
		class="bg-white-true border-orange fixed top-4 left-4 z-50 flex h-10 w-10 items-center justify-center rounded-full border"
	>
		<iconify-icon icon="heroicons-outline:menu-alt-1" class="text-orange text-2xl"></iconify-icon>
	</Popover.Trigger>
	<Popover.Content
		align="start"
		sideOffset={10}
		preventScroll={true}
		class="bg-white-true border-orange z-50 rounded border py-1 shadow"
		forceMount={true}
	>
		{#snippet child({ wrapperProps, props, open })}
			{#if open}
				<div {...wrapperProps}>
					<div {...props} transition:fly={{ y: -10 }}>
						{#each chapters as { title, href }, i (i)}
							<a
								{href}
								onclick={() => (popoverOpen = false)}
								class={[
									'hover:bg-orange-light/20 cta-small flex items-center gap-2 px-4 py-1 font-normal normal-case'
								]}
							>
								<div class="bg-orange h-0.5 w-3 rounded-full"></div>
								{title}
							</a>
						{/each}
					</div>
				</div>
			{/if}
		{/snippet}
	</Popover.Content>
</Popover.Root>
