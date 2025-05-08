// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

// Load images
import Hashcash from "src/vendor/hashcash";
require.context("../../images", true)

Hashcash.setup();
