const customPlugin = {
    statePlugins: {
      auth: {
        wrapSelectors: {
          authorized: (originalSelector, system) => () => {
            const securityDefinitions = system.specSelectors.securityDefinitions() || {};
            const oauthConfig = securityDefinitions.get('cognito'); // replace with your actual scheme name if different
  
            // Retrieve x-tokenName from the OAuth2 scheme if specified
            const tokenName = oauthConfig ? oauthConfig.get('x-tokenName') : 'Authorization';
  
            // Retrieve the `id_token` from Swagger UI's internal store if it exists
            const idToken = system.authSelectors.authorized().getIn(['OAuth2Auth', 'token', 'id_token']);
  
            // Set the custom token name with the `id_token` if available
            if (idToken) {
              return { [tokenName]: `Bearer ${idToken}` };
            }
  
            return originalSelector();
          }
        }
      }
    }
  };
  