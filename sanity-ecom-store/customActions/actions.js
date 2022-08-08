import defaultResolve, {PublishAction,DeleteAction} from 'part:@sanity/base/document-actions'
import addProduct from './addProduct'
import deleteProduct from './deleteProduct'

const customPublishAction =  (props) => {
  const defaultPublishAction = PublishAction(props)
  return {
    ...defaultPublishAction,
    onHandle: () => {
        addProduct(props)
        defaultPublishAction.onHandle()
    }
  }
}

const customDeleteAction = (props) => {
  const defaultDeleteAction = DeleteAction(props)
  return {
    ...defaultDeleteAction,
    onHandle: () => {
        deleteProduct(props)
        defaultDeleteAction.onHandle()
    }
  }
}

export default function resolveDocumentActions(props) {
  return [
      customPublishAction,
      customDeleteAction,
      ...defaultResolve(props).filter((action) => action.name !== 'PublishAction' && action.name !== 'DeleteAction'),
    ]
}