window.onload = function() {
  //<editor-fold desc="Changeable Configuration Block">

  // the following lines will be replaced by docker/configurator, when it runs in a docker-container
  window.ui = SwaggerUIBundle({
    //url: "https://petstore.swagger.io/v2/swagger.json",
    //url: "https://ssgg-swagger.s3.eu-north-1.amazonaws.com/SSGG.yaml",
    url: "https://github.com/ahmed-881994/SSGG-BE/blob/fbce32120736d429e043a9d4335823d5e5c7e3f9/API/SSGG.yaml",
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: "StandaloneLayout"
  });

  //</editor-fold>
};
