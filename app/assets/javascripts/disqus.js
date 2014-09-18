var disqus_initialized = false

function disqusInitialize() {
	if (disqus_initialized) return;

	/* * * DON'T EDIT BELOW THIS LINE * * */
    var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
    dsq.src = '//' + config.disqus.shortname + '.disqus.com/embed.js';

    var tag = (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0])
    tag.appendChild(dsq);

	disqus_initialized = true;
}

