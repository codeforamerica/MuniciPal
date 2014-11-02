// These need to be globals for Disqus to find and use them.
var disqus_shortname;
var disqus_identifier;
var disqus_url;

var DISQUS, config;

var disqusInitialize = function (identifier) {

  disqus_shortname = config.disqus.shortname;
  disqus_identifier = identifier;
  disqus_url = config.disqus.base_url + '/matters/' + identifier;

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