export default {
  name: "advertisement",

  title: "Advertisement",

  type: "document",

  fields: [
    {
      name: "name",

      title: "Ad Name",

      type: "string",
    },

    {
      name: "image",

      title: "Ad Image",

      type: "image",
    },

    {
      name: "slug",

      title: "Slug",

      type: "slug",

      options: {
        source: "name",

        maxLength: 96,
      },
    },
  ],
};
