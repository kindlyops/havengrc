import "./main.scss";

import { Elm } from './Main.elm'

if (process.env.NODE_ENV === 'development') {
  var FEATURE_ENV = 'development'
} else {
  var FEATURE_ENV = '{{.Env.FEATURE_ENV}}'
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
