How these files are named?
e.g. "norm_mix1  2  3db390_9classqn22negative_renorm_snr0.mat"
norm - the input sample is normlized including noise
mix1  2  3 -class NO.1,2&3 are mixed
db - database
390 - perclass samples(maybe not true for mixture classes)
9class - classes(maybe not true for mixture classes)
qn22 - Q[2,1], T=N/2, (if qn45, means Q=[4,1], T=N/5)
negative - negative frequency part(if positive, positive frequency part)
renorm - next layer is normalized from this layer
snr0 - signal to noise ratio is 0db(if, snr2000, no noise)
