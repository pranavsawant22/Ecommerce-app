export default {
    type: 'document',
    name: 'catagory',
    fields: [
      {
        name: 'kind',
        type: 'string',
        options: {list: ['SmartPhone', 'Tv', 'Laptop','Apparels','Books']},
      },
      {
        name: 'categoryImageMobile',
        title: 'categoryImageMobile',
        type: 'image',
      },
      {
        name: 'SmartPhone',
        type: 'object',
        hidden: ({parent}) => !(parent?.kind === 'SmartPhone'),
        fields: [
            {
            name : 'smartphoneSKU',
            title: 'smartphoneSKU',
            type : 'smartphone'
            },
        ],
      },
      {
        name: 'Apparels',
        type: 'object',
        hidden: ({parent}) => !(parent?.kind === 'Apparels'),
        fields: [ 
            {
            name : 'apparelsSKU',
            title: 'apparelsSKU',
            type : 'Apparels'
            },
        ],
      },
      {
        name: 'Tv',
        type: 'object',
        hidden: ({parent}) => !(parent?.kind === 'Tv'),
        fields: [ 
            {
            name : 'TvSKU',
            title: 'TvSKU',
            type : 'Tv'
            },
        ],
      },
      {
        name: 'Laptop',
        type: 'object',
        hidden: ({parent}) => !(parent?.kind === 'Laptop'),
        fields: [ 
            {
            name : 'LaptopSKU',
            title: 'LaptopSKU',
            type : 'Laptop'
            },
        ],
      },
      {
        name: 'Books',
        type: 'object',
        hidden: ({parent}) => !(parent?.kind === 'Books'),
        fields: [ 
            {
            name : 'BooksSKU',
            title: 'BooksSKU',
            type : 'Books'
            },
        ],
      },
    ]
}
   