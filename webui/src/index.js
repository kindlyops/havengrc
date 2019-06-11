import "./main.scss";

import { Elm } from './Main.elm'

if (process.env.NODE_ENV === 'development') {
  var CLIENT_ID = process.env.ELM_APP_KEYCLOAK_CLIENT_ID
} else {
  var CLIENT_ID = '{{.Env.ELM_APP_KEYCLOAK_CLIENT_ID}}'
}
var storedSurveyState = sessionStorage.getItem('storedSurvey')
var initialData = {
  storedSurvey: storedSurveyState ? JSON.parse(storedSurveyState) : null
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
      var i;
      console.log(spec);
      vegaEmbed("#vis", spec, { actions: false }).catch(console.warn);
    }
  });
}

elmApp.ports.renderVega.subscribe(updateChart);
