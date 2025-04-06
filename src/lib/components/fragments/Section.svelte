<script lang="ts" module>
	import { gsap } from 'gsap';
	import { ScrollTrigger } from 'gsap/ScrollTrigger';
	gsap.registerPlugin(ScrollTrigger);
</script>

<script lang="ts">
	let {
		children,
		background = true,
		padding = true,
		bordered = false,
		borderTop = bordered,
		borderBottom = bordered,
		class: classes = '',
		...rest
	} = $props();

	let section = $state<HTMLElement>();
	let active = $state(false);

	$effect(() => {
		if (!section) return;
		ScrollTrigger.create({
			trigger: section,
			start: 'top center',
			end: 'bottom center',
			onEnter: () => (active = true),
			onLeaveBack: () => (active = false)
		});
	});
</script>

<section
	bind:this={section}
	class={[
		'border-gray relative',
		padding && 'py-16',
		background && 'bg-white',
		borderTop && 'border-t',
		borderBottom && 'border-b',
		classes
	]}
	{...rest}
>
	<div
		class={[
			'ease-[cubic-bezier(0.65, 0, 0.35, 1)] flex flex-col gap-16 transition-all duration-500',
			active ? 'translate-y-0 opacity-100' : 'translate-y-6 opacity-0'
		]}
	>
		{@render children?.()}
	</div>
</section>
