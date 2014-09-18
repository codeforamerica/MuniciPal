var disqusInitialize = function (identifier) {

  var disqus_shortname = config.disqus.shortname;
  var disqus_identifier = identifier;
  var disqus_url = config.disqus.base_url + identifier;

  if(typeof DISQUS === "undefined") {
    /* * * DON'T EDIT THIS BLOCK PROVIDED BY DISQUS * * */
    (function() {
      var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
      dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
      (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
  } else {
    DISQUS.reset({
      reload: true,
      config: function () {
        this.page.identifier = disqus_identifier;
        this.page.url = disqus_url;
      }
    });
  }
};