import React from "react";
import {
  Box,
  IconButton,
  InputBase,
  useMediaQuery,
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import classes from "../../utils/classes";
import { useState } from "react";
import { useRouter } from 'next/router';


export const Search = () => {
  const router = useRouter();
  const isDesktop = useMediaQuery('(min-width:600px)');
  const [query, setQuery] = useState('');
  const searchQueryHandler = (e) => {
    setQuery(e.target.value);
  };
  
  const submitHandler = (e) => {
    e.preventDefault();
    router.push(`/search?query=${query}`);
  };
 
  return (
      <form onSubmit={submitHandler}>
      <Box sx={classes.searchForm}>
        <InputBase
          name="query"
          sx={ isDesktop ? classes.searchInput : classes.searchInputMobile}
          placeholder="Search products"
          onChange={searchQueryHandler}
          endAdornment={
            <IconButton type="submit" sx={isDesktop ? classes.searchButton : classes.searchButtonMobile} aria-label="search">
          <SearchIcon />
        </IconButton>
          }
        /> 
      </Box>
    </form>
  );
};
