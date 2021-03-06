data{
  //how many
  int N;
  int K;
  int Nsite;
  int Nprovenance;
  int Nclone;
  int Nyear;
  //int Ntree;
  // data
  int state[N];
  vector[N] forcing;
  int SiteID[N];
  int ProvenanceID[N];
  int CloneID[N];
  int YearID[N];
 // int TreeID[N];
}

parameters{
  positive_ordered[K-1] kappa;
  real<lower=0> beta;
  vector[Nsite] b_site;
  //vector[Nsite] z_site;
  //vector[Nprovenance] z_prov;
  vector[Nprovenance] b_prov;
  //vector[Nclone] b_clone;
  vector[Nclone] z_clone;
  vector[Nyear] z_year;
  //vector[Nyear] b_year;
  //vector[Ntree] b_tree;
  //vector[Ntree] z_tree;
  real<lower=0> sigma_site;
  real<lower=0> sigma_prov;
  real<lower=0> sigma_clone;
  real<lower=0> sigma_year;
//  real<lower=0> sigma_tree;
}


model{
  vector[N] phi;
  beta ~ exponential(2);
  kappa ~ normal( 0, 1 ) ;
  
  // adaptive priors on effects
  sigma_site ~ exponential( 5 );
  sigma_prov ~ exponential( 5 );
  sigma_clone ~ exponential( 5 );
  sigma_year ~ exponential( 5 );
  //sigma_tree ~ exponential( 5);
  b_site ~ normal( 0 , sigma_site );
  //z_site ~ normal(0, 1);
  // z_prov ~ normal( 0 , 1 );
  b_prov ~ normal( 0 , sigma_prov );
  //b_clone ~ normal( 0 , sigma_clone );
  z_clone ~ normal(0, 1);
  z_year ~ normal( 0 , 1 );
  //b_year ~ normal( 0 , sigma_year );
//  b_tree ~ normal(0, sigma_tree);
  //z_tree ~ normal(0,1);
  
  // model
  
  for ( i in 1:N ) {
    phi[i] = forcing[i] * ( beta + b_site[SiteID[i]] + b_prov[ProvenanceID[i]] + z_clone[CloneID[i]]*sigma_clone + z_year[YearID[i]]*sigma_year );
    //phi[i] = forcing[i] * (beta + z_site[SiteID[i]]*sigma_site + z_prov[ProvenanceID[i]]*sigma_prov + 
    // z_clone[CloneID[i]]*sigma_clone + z_year[YearID[i]]*sigma_year + z_tree[TreeID[i]]*sigma_tree);
  }
  for ( i in 1:N ) state[i] ~ ordered_logistic( phi[i] , kappa );
}

generated quantities{
  
  //centered vars
  // vector[Nprovenance] b_prov;
   vector[Nyear] b_year;
  // vector[Nsite] b_site;
   vector[Nclone] b_clone;
  // vector[Ntree] b_tree;
  
  //mean effects
  real b_site_mean;
  real b_clone_mean;
  real b_year_mean;
  real b_prov_mean;
 // real b_tree_mean;
 
 //kappas on risto scale
 vector[K-1] kappa_rs;
  
  //ppc y_rep : uncomment to generate ppc yrep
 // vector[N] phi;
 // vector[N] state_rep;
  
  // recalculate b parameters that were un-centered
  b_year = z_year*sigma_year;
  // b_prov = z_prov*sigma_prov;
  // b_site = z_site*sigma_site;
   b_clone = z_clone*sigma_clone;
  // b_tree = z_tree*sigma_tree;
  
  // calculate mean effects across groups
  b_site_mean = mean(b_site);
  b_prov_mean = mean(b_prov);
  b_clone_mean = mean(b_clone);
  b_year_mean = mean(b_year);
 // b_tree_mean = mean(b_tree);
 
 // calculate h50s on scaled risto scale
 kappa_rs = (kappa* 1.527) + (beta * -11.975);
 
  
  // simulate data for model testing
//   for ( i in 1:N ) {
//     phi[i] = forcing[i] * (beta + b_site[SiteID[i]] + b_prov[ProvenanceID[i]] + b_clone[CloneID[i]] + b_year[YearID[i]]);
//   }
//   
//   for (i in 1:N) {
//     state_rep[i] = ordered_logistic_rng(phi[i], kappa);
//   }
}

