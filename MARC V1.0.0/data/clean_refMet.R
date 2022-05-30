 setwd("C:/software/phpstudy_pro/WWW/metabolism/data/refMet/compound")
 file=list.files()
 m=length(file)
 res=c()
 for(i in  1:m){
 data=read.csv(file[i])
 res=rbind(res,data)
 }
 
 write.csv(res,"refMet_all_compound.csv",row.names=FALSE)
 
 ####
 setwd("C:/software/phpstudy_pro/WWW/metabolism/data/refMet")
 hmdb=read.csv("hmdb_database_normalize.csv")
 hmdb.cid=as.character(hmdb[,1])
 pathbank=read.csv("pathbank_database_normalize.csv")
 pathbank.cid=as.character(pathbank[,1])
 aiiccs=read.csv("aiiccs_database_normalize.csv")

 aiiccs.cid=as.character(aiiccs[,1])
 m=length(aiiccs.cid)
 for(i in 1:m){
         hm=which(hmdb.cid==aiiccs.cid[i])
         if(length(hm)>0){
                 aiiccs[i,"extend1.ID"]=hmdb[hm[1],"extend1.ID"]
         }else{
                pb=which(pathbank.cid==aiiccs.cid[i])
                if(length(pb)>0){
                        aiiccs[i,"extend1.ID"]=pathbank[pb[1],"extend1.ID"]
                }else{
                        aiiccs[i,"extend1.ID"]=NA
                }
         }
         
         
 }
 pathbank.InChIKey=pathbank[,"InChIKey"]
 hmdb.InChIKey=hmdb[,"InChIKey"]
 aiiccs.InChIKey=as.character(aiiccs[,"InChIKey"])
 m=length(aiiccs.InChIKey)
 for(i in 1:m){
         hm=which(hmdb.InChIKey==aiiccs.InChIKey[i])
         if(length(hm)>0){
                 aiiccs[i,"extend1.ID"]=hmdb[hm[1],"extend1.ID"]
         }else{
                 pb=which(pathbank.InChIKey==aiiccs.InChIKey[i])
                 if(length(pb)>0){
                         aiiccs[i,"extend1.ID"]=pathbank[pb[1],"extend1.ID"]
                 }else{
                         aiiccs[i,"extend1.ID"]=NA
                 }
         }
         
         
 }
 
 aiiccs=aiiccs[!duplicated(as.character(aiiccs[,"SMILES"])),]
 write.csv(aiiccs,"aiiccs_database_normalize_hmdb.csv",row.names = FALSE)
 
 
 ###ChEBI_database_normalize.csv
 
 aiiccs=read.csv("ChEBI_database_normalize.csv")
 
 aiiccs.cid=as.character(aiiccs[,1])
 m=length(aiiccs.cid)
 for(i in 1:m){
         hm=which(hmdb.cid==aiiccs.cid[i])
         if(length(hm)>0){
                 aiiccs[i,"extend1.ID"]=hmdb[hm[1],"extend1.ID"]
         }else{
                 pb=which(pathbank.cid==aiiccs.cid[i])
                 if(length(pb)>0){
                         aiiccs[i,"extend1.ID"]=pathbank[pb[1],"extend1.ID"]
                 }else{
                         aiiccs[i,"extend1.ID"]=NA
                 }
         }
         
         
 }
 aiiccs.InChIKey=as.character(aiiccs[,"InChIKey"])
 m=length(aiiccs.InChIKey)
 for(i in 1:m){
         hm=which(hmdb.InChIKey==aiiccs.InChIKey[i])
         if(length(hm)>0){
                 aiiccs[i,"extend1.ID"]=hmdb[hm[1],"extend1.ID"]
         }else{
                 pb=which(pathbank.InChIKey==aiiccs.InChIKey[i])
                 if(length(pb)>0){
                         aiiccs[i,"extend1.ID"]=pathbank[pb[1],"extend1.ID"]
                 }else{
                         aiiccs[i,"extend1.ID"]=NA
                 }
         }
         
         
 }
 
 #aiiccs=aiiccs[!duplicated(as.character(aiiccs[,"SMILES"])),]
 write.csv(aiiccs,"ChEBI_database_normalize_hmdb.csv",row.names = FALSE)
 
 
 ####kegg
 aiiccs=read.csv("kegg_database_normalize.csv")
 pathbank_pathway=read.csv("pathbank_metabolite_pathway.csv")
 pp=as.character(pathbank_pathway[,3])
 aiiccs.id=as.character(aiiccs[,"extend.ID"])
 m=length(aiiccs.id)
 for(i in 1:m){
         hm=which(pp==aiiccs.id[i])
         if(length(hm)>0){
                 aiiccs[i,"extend1.ID"]=pathbank_pathway[hm[1],2]
         }else{
                         aiiccs[i,"extend1.ID"]=NA
                 
         }
         
         
 }
 
 #aiiccs=aiiccs[!duplicated(as.character(aiiccs[,"SMILES"])),]
 write.csv(aiiccs,"kegg_database_normalize_hmdb.csv",row.names = FALSE)
 
 
 ###massbank
 
 aiiccs=read.csv("ms_database_normalize.csv")
 

 aiiccs.InChIKey=as.character(aiiccs[,"InChIKey"])
 m=length(aiiccs.InChIKey)
 for(i in 1:m){
         hm=which(hmdb.InChIKey==aiiccs.InChIKey[i])
         if(length(hm)>0){
                 aiiccs[i,"extend1.ID"]=hmdb[hm[1],"extend1.ID"]
         }else{
                 pb=which(pathbank.InChIKey==aiiccs.InChIKey[i])
                 if(length(pb)>0){
                         aiiccs[i,"extend1.ID"]=pathbank[pb[1],"extend1.ID"]
                 }else{
                         aiiccs[i,"extend1.ID"]=NA
                 }
         }
         
         
 }
 
 #aiiccs=aiiccs[!duplicated(as.character(aiiccs[,"SMILES"])),]
 write.csv(aiiccs,"ms_database_normalize_hmdb.csv",row.names = FALSE)
 
 
 ###NPA
 
 aiiccs=read.csv("NPA_database_normalize.csv")
 
 
 aiiccs.InChIKey=as.character(aiiccs[,"InChIKey"])
 m=length(aiiccs.InChIKey)
 for(i in 1:m){
         hm=which(hmdb.InChIKey==aiiccs.InChIKey[i])
         if(length(hm)>0){
                 aiiccs[i,"extend1.ID"]=hmdb[hm[1],"extend1.ID"]
         }else{
                 pb=which(pathbank.InChIKey==aiiccs.InChIKey[i])
                 if(length(pb)>0){
                         aiiccs[i,"extend1.ID"]=pathbank[pb[1],"extend1.ID"]
                 }else{
                         aiiccs[i,"extend1.ID"]=NA
                 }
         }
         
         
 }
 
 #aiiccs=aiiccs[!duplicated(as.character(aiiccs[,"SMILES"])),]
 write.csv(aiiccs,"NPA_database_normalize_hmdb.csv",row.names = FALSE)
 

 ####构建GMT文件
 setwd("C:/software/phpstudy_pro/WWW/metabolism/data/refMet")
 data=read.csv("pathbank_metabolite_pathway.csv")
path=read.csv("human_pathway_pathbank.csv")
 pathway=as.character(data[,1])
 pp=as.character(path[,1])
 m=length(pp)
 sink('Geneset.gmt')
 for(i in 1:m){
         pa=which(pathway==pp[i])
         name=as.character(data[pa,2])
         res=paste(name,collapse = '\t')
         cat(pp[i])
         cat('\tNA\t')
         cat(res)
         cat('\n')        
         
 }

 sink()
 
 
 #################protein
 setwd("C:/software/phpstudy_pro/WWW/metabolism/data/refMet/")
 data=read.csv("hmdb_proteins.csv")
 protein=as.character(data[,12])
 gene=data[,c(8,9,18,22)]
 hmdb=read.csv("hmdb_database_normalize.csv")
 hid=as.character(hmdb[,"extend.ID"])
 m=length(hid)
 res=c()
 for (i in 1:m) {
         ss=grep(hid[i],protein,fixed = TRUE)
         if(length(ss)>0)
         {
        re=cbind(hid[i],gene[ss,])
         
         res=rbind(res,re)
         }
 }
 colnames(res)=c("hmdb.ID","gene.name","gene.function","unport.ID","genecard.ID")
 write.csv(res,"hmdb_compound_protein.csv",row.names = FALSE)

  
######################################
 
 setwd("C:/software/phpstudy_pro/WWW/metabolism/data/refMet/compound")
 data=read.csv("kegg_database_normalize_hmdb.csv")
 ext=as.character(data[,"extend1.ID"])
 dd=which(is.na(ext))
 data[dd,"extend1.ID"]=data[dd,"extend.ID"]

 write.csv(data,"kegg_database_normalize_hmdb_kegg.csv",row.names=FALSE)

#########clean CID
 setwd("C:/software/phpstudy_pro/WWW/metabolism/data/refMet/compound")
 data=read.csv("kegg_database_normalize_hmdb.csv")
 file=list.files()
 m=length(file)
 for (i in 1:m) {
   data=read.csv(file[i])
   data=data[!duplicated(as.character(data[,1])),]
   write.csv(data,file[i],row.names = FALSE)
 }
 

 