#include<Rmath.h>
#include<RcppCommon.h>
#include<RcppArmadillo.h>

// [[Rcpp::depends(RcppArmadillo)]]
using std::string;
using Rcpp::Named;
using namespace arma;

// [[Rcpp::export]]
extern "C" SEXP mvest(const cube& Yt){
  
  const int p = Yt.n_rows, q = Yt.n_cols, n = Yt.n_slices;

  cube MR0(p, p, n, fill::zeros);
  cube MC0(q, q, n, fill::zeros);
  for (int i = 0; i < n; i++){
    MR0.slice(i) = Yt.slice(i) * Yt.slice(i).t();
    MC0.slice(i) = Yt.slice(i).t() * Yt.slice(i);
  }
  mat MR = mean(MR0, 2) / (p * q);
  mat MC = mean(MC0, 2) / (p * q);
  
  int Rcl = ceil(p / 2);
  cx_vec Reigval0;
  cx_mat Reigvec0;
  eig_gen(Reigval0, Reigvec0, MR);
  vec Reigval = real(Reigval0);
  mat Reigvec = real(Reigvec0);
  uword k0 = index_max(Reigval.col(0).subvec(0, Rcl-2) / Reigval.col(0).subvec(1, Rcl-1));
  
  int Ccl = ceil(q / 2);
  cx_vec Ceigval0;
  cx_mat Ceigvec0;
  eig_gen(Ceigval0, Ceigvec0, MC);
  vec Ceigval = real(Ceigval0);
  mat Ceigvec = real(Ceigvec0);
  uword r0 = index_max(Ceigval.col(0).subvec(0, Ccl-2) / Ceigval.col(0).subvec(1, Ccl-1));
  int k, r; k = (int)k0 + 1; r = (int)r0 + 1;
  
  mat Rhat = sqrt(p) * Reigvec.cols(0, k-1);
  mat Chat = sqrt(q) * Ceigvec.cols(0, r-1);
  cube Zhat(k, r, n, fill::zeros);
  
  for (int i = 0; i < n; i++){
    Zhat.slice(i) = Rhat.t() * Yt.slice(i) * Chat / (p*q);
  }
    
  return Rcpp::List::create(
    Named("k") = k, 
    Named("r") = r,
    Named("Rhat") = Rhat, 
    Named("Chat") = Chat, 
    Named("Zhat") = Zhat
  );
}