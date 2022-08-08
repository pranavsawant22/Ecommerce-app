import { ListItem, Typography } from "@mui/material";
import React from "react";

const Tv = ({props}) => {

  return (
    <>
      <ListItem>
        <Typography>Description: {props.description}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Display: {props.display}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Screent Size: {props.ScreenSize}</Typography>
      </ListItem>
    </>
  );
};

export default Tv;
