clear
Table = table();

exnum = [9, 11, 12, 14, 15, 17];
% exnum = [9];
% PELVIS, SPINE_NAVAL, SPINE_CHEST, NECK, CLAVICLE_LEFT, SHOULDER_LEFT, ELBOW_LEFT, WRIST_LEFT, HAND_LEFT, HANDTIP_LEFT	, THUMB_LEFT, CLAVICLE_RIGHT, SHOULDER_RIGHT, ELBOW_RIGHT, WRIST_RIGHT, HAND_RIGHT, HANDTIP_RIGHT, THUMB_RIGHT, HIP_LEFT, KNEE_LEFT, ANKLE_LEFT	, FOOT_LEFT, HIP_RIGHT, KNEE_RIGHT, ANKLE_RIGHT	, FOOT_RIGHT, HEAD	, NOSE	, EYE_LEFT	, EAR_LEFT	, EYE_RIGHT	, EAR_RIGHT, WRIST_LEFTw, HAND_LEFTw, HANDTIP_LEFTw, dTHUMB_LEFTw = []
feature = ["PELVIS", "SPINE_NAVAL", "SPINE_CHEST", "NECK", "CLAVICLE_LEFT", "SHOULDER_LEFT",...
 "ELBOW_LEFT", "WRIST_LEFT", "HAND_LEFT", "HANDTIP_LEFT", "THUMB_LEFT", "CLAVICLE_RIGHT",...
 "SHOULDER_RIGHT", "ELBOW_RIGHT", "WRIST_RIGHT", "HAND_RIGHT", "HANDTIP_RIGHT", "THUMB_RIGHT",...
 "HIP_LEFT", "KNEE_LEFT", "ANKLE_LEFT", "FOOT_LEFT", "HIP_RIGHT", "KNEE_RIGHT", "ANKLE_RIGHT",...
 "FOOT_RIGHT", "HEAD", "NOSE", "EYE_LEFT", "EAR_LEFT", "EYE_RIGHT", "EAR_RIGHT",...
 "WRIST_RIGHTw", "HAND_RIGHTw", "HANDTIP_RIGHTw", "THUMB_RIGHTw"];
for i = 1:size(exnum, 2)
    v3 = readmatrix("0331v3ForwardData/" + exnum(i) + "/0/poslabel.csv");
    v3(:,2:97) = lowpass(v3(:,2:97), 0.3);
    T = table(v3(:,1));
    for j = 2:3:95
        jointPosition = vecnorm(v3(:,j:j+2)-v3(:,2:4),2,2);
        T = addvars(T, jointPosition, [diff(jointPosition); 0], [diff(jointPosition, 2); 0; 0]);
    end
    label = strings(size(v3(:,98)));
    label(v3(:,98)==0) = "Released";
    label(v3(:,98)~=0) = "Grabbing";
    
    SHOULDER_LEFT = v3(:,17:19);
    ELBOW_LEFT = v3(:,20:22);
    WRIST_LEFT = v3(:,23:25);
    
    SHOULDER_RIGHT = v3(:,38:40);
    ELBOW_RIGHT = v3(:,41:43);
    WRIST_RIGHT = v3(:,44:46);
    
    HIP_LEFT = v3(:,56:58);
    KNEE_LEFT = v3(:,59:61);
    ANKLE_LEFT = v3(:,62:64);
    
    HIP_RIGHT = v3(:,68:70);
    KNEE_RIGHT = v3(:,71:73);
    ANKLE_RIGHT = v3(:,74:76);
    
    PELVIS = v3(:,2:4);
    SPINE_NAVAL = v3(:,5:7);
    
    EL2WL = WRIST_LEFT-ELBOW_LEFT;
    EL2SL = SHOULDER_LEFT-ELBOW_LEFT;
    EL_theta = getAngle(EL2WL, EL2SL);
    dEL_theta = [diff(EL_theta); 0];
    ddEL_theta = [diff(dEL_theta); 0];
    
    PE2SP = SPINE_NAVAL-PELVIS;
    HL2KL = KNEE_LEFT-HIP_LEFT;
    HL_theta = getAngle(PE2SP, HL2KL);
    dHL_theta = [diff(HL_theta); 0];
    ddHL_theta = [diff(dHL_theta); 0];
    
    KL2HL = HIP_LEFT-KNEE_LEFT;
    KL2AL = ANKLE_LEFT-KNEE_LEFT;
    KL_theta = getAngle(KL2HL, KL2AL);
    dKL_theta = [diff(KL_theta); 0];
    ddKL_theta = [diff(dKL_theta); 0];
    
    ER2WR = WRIST_RIGHT-ELBOW_RIGHT;
    ER2SR = SHOULDER_RIGHT-ELBOW_RIGHT;
    ER_theta = getAngle(ER2WR, ER2SR);
    dER_theta = [diff(ER_theta); 0];
    ddER_theta = [diff(dER_theta); 0];
    
    HR2KR = KNEE_RIGHT-HIP_RIGHT;
    HR_theta = getAngle(PE2SP, HR2KR);
    dHR_theta = [diff(HR_theta); 0];
    ddHR_theta = [diff(dHR_theta); 0];
    
    KR2HR = HIP_RIGHT-KNEE_RIGHT;
    KR2AR = ANKLE_RIGHT-KNEE_RIGHT;
    KR_theta = getAngle(KR2HR, KR2AR);
    dKR_theta = [diff(KR_theta); 0];
    ddKR_theta = [diff(dKR_theta); 0];
    
    WRIST_RIGHTw = vecnorm(v3(:,44:46),2, 2);
    HAND_RIGHTw = vecnorm(v3(:,47:49),2, 2);
    HANDTIP_RIGHTw = vecnorm(v3(:,50:52),2, 2);
    THUMB_RIGHTw = vecnorm(v3(:,53:55),2, 2);
    
    dWRIST_RIGHTw = [abs(diff(WRIST_RIGHTw)); 0];
    dHAND_RIGHTw = [abs(diff(HAND_RIGHTw)); 0];
    dHANDTIP_RIGHTw = [abs(diff(HANDTIP_RIGHTw)); 0];
    dTHUMB_RIGHTw = [abs(diff(THUMB_RIGHTw)); 0];
    
    ddWRIST_RIGHTw = [abs(diff(dWRIST_RIGHTw)); 0];
    ddHAND_RIGHTw = [abs(diff(dHAND_RIGHTw)); 0];
    ddHANDTIP_RIGHTw = [abs(diff(dHANDTIP_RIGHTw)); 0];
    ddTHUMB_RIGHTw = [abs(diff(dTHUMB_RIGHTw)); 0];
    
    T = addvars(T, dWRIST_RIGHTw, ddWRIST_RIGHTw, dHAND_RIGHTw, ddHAND_RIGHTw,...
        dHANDTIP_RIGHTw, ddHANDTIP_RIGHTw, dTHUMB_RIGHTw, ddTHUMB_RIGHTw,...
        EL_theta, dEL_theta, ddEL_theta, HL_theta, dHL_theta, ddHL_theta, KL_theta, dKL_theta, ddKL_theta,...
        ER_theta, dER_theta, ddER_theta, HR_theta, dHR_theta, ddHR_theta, KR_theta, dKR_theta, ddKR_theta,...
        label);
    T(:,1:4) = []; % 日付と腰の予測子を削除 
    for k = 1:31
        T.Properties.VariableNames{strcat('jointPosition_', num2str(k))} = char(feature(k+1));
        T.Properties.VariableNames{strcat('Var', num2str(3 + 3*k))} = char(strcat('d', feature(k+1)));
        T.Properties.VariableNames{strcat('Var', num2str(4 + 3*k))} = char(strcat('dd', feature(k+1)));
    end
    T(size(T, 1)-1:size(T, 1),:) = []; % 差分で失われたデータを削除 
    Table = [Table;T];
end