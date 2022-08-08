import { Alert, Card, CircularProgress, Grid, List, ListItem, Rating, Typography } from "@mui/material";
import React, { useEffect, useState } from "react";
import classes from "../../utils/classes";
import AccountBoxIcon from '@mui/icons-material/AccountBox';
import axios from "axios";

const ProductReview = ({props}) => {

  const [state, setState] = useState({
    reviews: [],
    error: "",
    loading: true,
    reviewCheck : false
  });

  const { reviews , error, loading, reviewCheck } = state;

    useEffect(() => {
      const fetchReviews = async () => {        
        try{
          setState({ loading: true });
          const  {data}  = await axios.get(
            `https://auth-service-capstone.herokuapp.com/api/v1/rating-review/get-rating-review-by-productid/${props.productId}`,
          );
          reviews = data;
          reviewCheck=reviews.length!==0
          console.log(reviews);
          setState({ reviews, loading: false , reviewCheck });
        } catch (err) {
          console.log("error")
          setState({ error: err.message, loading: false , reviewCheck });
        }
      };
      fetchReviews();
    }, []);
  
  return (
    <>
      {loading ? (
        <CircularProgress />
      ) : error ? (
        <Alert variant="error">{error}</Alert>
      ) : (
      <>
      {reviewCheck && reviews.map((review) => (
        <Card sx={classes.review}>
          <Grid container spacing={1}>
            <Grid item md={12} xs={12}>
              <List spaching={3}>
                <ListItem>
                    <AccountBoxIcon  fontSize="large"/>
                  <Typography component="h1" variant="h1">
                    {review.firstName}
                  </Typography>
                  <Rating value={review.rating} readOnly></Rating>
                </ListItem>
                <ListItem>
                  <Typography varient="h2"> {review.comment}</Typography>
                </ListItem>
              </List>
            </Grid>
          </Grid>
        </Card>
      ))}
      {!reviewCheck && <Typography component="h1" variant="h1"> No Reviews Found for this Product</Typography>}
      </>)}
    </>
  );
};

export default ProductReview;
