import "./main.scss";

import { Elm } from './Main.elm'

if (process.env.NODE_ENV === 'development') {
  var FEATURE_ENV = 'development'
} else {
  var FEATURE_ENV = 'production'
}

var storedSurveyState = sessionStorage.getItem('storedSurvey')
var initialData = {
  storedSurvey: storedSurveyState ? JSON.parse(storedSurveyState) : null,
  featureEnv: FEATURE_ENV
}

document.arrive("#lottie", () => {
  var element = document.getElementById('lottie');
  var animationPath = process.env.PUBLIC_URL + '/animations/haven-demo.json'
  if (element) {
    console.log("got lottie element");
    lottie.setLocationHref(document.location.href)
    lottie.loadAnimation({
      container: element, // Required
      path: animationPath, // Required
      renderer: 'svg', // Required
      loop: true, // Optional
      autoplay: true, // Optional
    });
  }
});

var elmApp = Elm.Main.init({
  node: document.getElementById('elm'),
  flags: initialData
});

elmApp.ports.radarChart.subscribe(chartConfig => {
  chartConfig.type = 'radar'
  window.myRadar = new Chart(document.getElementById('chart'), chartConfig)
})

elmApp.ports.saveSurveyState.subscribe(storedSurvey => {
  sessionStorage.setItem('storedSurvey', JSON.stringify(storedSurvey));
})

let updateChart = function (spec) {
  //console.log("updateChart was called");
  window.requestAnimationFrame(() => {
    var element = $('#vis');
    if (element.length) {
      console.log(spec);
      vegaEmbed("#vis", spec, { actions: false }).catch(console.warn);
    }
  });
}

elmApp.ports.renderVega.subscribe(updateChart);

(function (w,d) {
  var loader = function () {
    var s = d.createElement("script"), tag = d.getElementsByTagName("script")[0];
    s.src="https://cdn.iubenda.com/iubenda.js";
    tag.parentNode.insertBefore(s,tag);
    // Add an observer to adjust the style of the iubenda buttons
    // after they are added to the iframe.
    observer.observe(document.body, config);
  };
  if(w.addEventListener){
    w.addEventListener("load", loader, false);
  }else if(w.attachEvent){
    w.attachEvent("onload", loader);
  }else{
    w.onload = loader;
  }
  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
        if (mutation.addedNodes && mutation.addedNodes.length > 0) {
            // element added to DOM
            var hasClass = [].some.call(mutation.addedNodes, function(el) {
                var found = document.getElementsByClassName('iubenda-ibadge');
                if (found) {
                  return found;
                }
                  return;
            });
            if (hasClass) {
              var el = document.getElementsByClassName('iubenda-ibadge');
              for (var i = 0; i < el.length; i++) {
                el[i].classList.add("ml-3");
                el[i].classList.add("align-middle");
              };
             }
        }
    });
  });

  var config = {
    attributes: true,
    childList: true,
    characterData: true
  };

})(window, document);