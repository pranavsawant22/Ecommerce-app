import Typesense from 'typesense'

const API_KEY = process.env.SANITY_STUDIO_API_KEY
const HOST = process.env.SANITY_STUDIO_HOST
const PORT = process.env.SANITY_STUDIO_PORT
const PROTOCOL = process.env.SANITY_STUDIO_PROTOCOL

const deleteProduct = async (doc) => {  
  if(doc.type === "product"){
    // preprocess doc
    const slug = Object.values(Object.values(doc.published.catagory.productsku)[0])[0].slug.current

    // typesense client
    const client = new Typesense.Client({
      nodes: [
        {
          host: HOST,
          port: PORT,
          protocol: PROTOCOL
        }
      ],
      apiKey: API_KEY,
      connectionTimeoutSeconds: 2,
    })

    // delete the existing doc in typesense if it exists
    try {
      const result = await client.collections('products').documents().delete({'filter_by': `slug:${slug}`})
    } catch (err) {
      console.log('typesense delete error : ',err)
    }
  }
}

export default deleteProduct