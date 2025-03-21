function truncAxis(varargin)
% Refer to https://blog.csdn.net/slandarer/article/details/126319506

% parsing handle
if isa(varargin{1},'matlab.graphics.axis.Axes')
    ax=varargin{1};varargin(1)=[];
else
    ax=gca;
end
hold(ax,'on');
% box(ax,'off')
ax.XAxisLocation='bottom';
ax.YAxisLocation='left';

axisPos=ax.Position;
axisXLim=ax.XLim;
axisYLim=ax.YLim;

axisXScale=diff(axisXLim);
axisYScale=diff(axisYLim);


truncRatio=1/20;
Xtrunc=[];Ytrunc=[];
for i=1:length(varargin)-1
    switch true
        case strcmpi('X',varargin{i}),Xtrunc=varargin{i+1};
        case strcmpi('Y',varargin{i}),Ytrunc=varargin{i+1};
    end
end


switch true
    case isempty(Xtrunc)
        % copy axes
        ax2=copyAxes(ax);
        % Adjust general properties
        ax2.XTickLabels=[];
        ax2.XColor='none';
        % Configure the ax range
        ax.YLim=[axisYLim(1),Ytrunc(1)];
        ax2.YLim=[Ytrunc(2),axisYLim(2)];
        % Relocating the ax locations
        ax.Position(4)=axisPos(4)*(1-truncRatio)/(axisYScale-diff(Ytrunc))*(Ytrunc(1)-axisYLim(1));
        ax2.Position(2)=axisPos(2)+ax.Position(4)+axisPos(4)*truncRatio;
        ax2.Position(4)=axisPos(4)*(1-truncRatio)/(axisYScale-diff(Ytrunc))*(axisYLim(2)-Ytrunc(2));
        % link the ax variation
        linkaxes([ax,ax2],'x')
        % Add lines and annotaions
        if strcmp(ax.Box,'on')
        ax.Box='off';ax2.Box='off';
        annotation('line',[1,1].*(ax.Position(1)+ax.Position(3)),[ax.Position(2),ax.Position(2)+ax.Position(4)],'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[1,1].*(ax.Position(1)+ax.Position(3)),[ax2.Position(2),ax2.Position(2)+ax2.Position(4)],'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[ax.Position(1),ax.Position(1)+ax.Position(3)],[1,1].*(ax2.Position(2)+ax2.Position(4)),'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        else
        annotation('line',[ax.Position(1),ax.Position(1)+ax.Position(3)],[1,1].*(ax.Position(2)+ax.Position(4)),'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[ax.Position(1),ax.Position(1)+ax.Position(3)],[1,1].*(ax2.Position(2)),'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        end
        createSlash([ax.Position(1)-.2,ax.Position(2)+ax.Position(4)-.2,.4,.4])
        createSlash([ax.Position(1)-.2,ax2.Position(2)-.2,.4,.4])
        createSlash([ax.Position(1)+ax.Position(3)-.2,ax.Position(2)+ax.Position(4)-.2,.4,.4])
        createSlash([ax.Position(1)+ax.Position(3)-.2,ax2.Position(2)-.2,.4,.4])
    case isempty(Ytrunc) 
        % copy axes
        ax2=copyAxes(ax);
        % Adjust general properties
        ax2.YTickLabels=[];
        ax2.YColor='none';
        % Configure the ax range
        ax.XLim=[axisXLim(1),Xtrunc(1)];
        ax2.XLim=[Xtrunc(2),axisXLim(2)];
        % Relocating the ax locations
        ax.Position(3)=axisPos(3)*(1-truncRatio)/(axisXScale-diff(Xtrunc))*(Xtrunc(1)-axisXLim(1));
        ax2.Position(1)=axisPos(1)+ax.Position(3)+axisPos(3)*truncRatio;
        ax2.Position(3)=axisPos(3)*(1-truncRatio)/(axisXScale-diff(Xtrunc))*(axisXLim(2)-Xtrunc(2));
        % link the ax variation
        linkaxes([ax,ax2],'y')
        % Add lines and annotaions
        if strcmp(ax.Box,'on')
        ax.Box='off';ax2.Box='off';
        annotation('line',[ax.Position(1),ax.Position(1)+ax.Position(3)],[1,1].*(ax.Position(2)+ax.Position(4)),'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[ax2.Position(1),ax2.Position(1)+ax2.Position(3)],[1,1].*(ax.Position(2)+ax.Position(4)),'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[1,1].*(ax2.Position(1)+ax2.Position(3)),[ax2.Position(2),ax2.Position(2)+ax2.Position(4)],'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        else
        annotation('line',[1,1].*(ax.Position(1)+ax.Position(3)),[ax2.Position(2),ax2.Position(2)+ax2.Position(4)],'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[1,1].*(ax2.Position(1)),[ax2.Position(2),ax2.Position(2)+ax2.Position(4)],'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        end
        createSlash([ax.Position(1)+ax.Position(3)-.2,ax.Position(2)-.2,.4,.4])
        createSlash([ax2.Position(1)-.2,ax.Position(2)-.2,.4,.4])
        createSlash([ax.Position(1)+ax.Position(3)-.2,ax.Position(2)+ax.Position(4)-.2,.4,.4])
        createSlash([ax2.Position(1)-.2,ax.Position(2)+ax.Position(4)-.2,.4,.4])
    case (~isempty(Ytrunc))&(~isempty(Ytrunc))
        % copy axes
        ax2=copyAxes(ax);
        ax3=copyAxes(ax);
        ax4=copyAxes(ax);
        % Adjust general properties
        ax2.XTickLabels=[];
        ax2.XColor='none';
        ax3.XTickLabels=[];
        ax3.XColor='none';
        ax3.YTickLabels=[];
        ax3.YColor='none';
        ax4.YTickLabels=[];
        ax4.YColor='none';
        % Configure the ax range
        ax.YLim=[axisYLim(1),Ytrunc(1)];
        ax.XLim=[axisXLim(1),Xtrunc(1)];
        ax2.XLim=[axisXLim(1),Xtrunc(1)];
        ax2.YLim=[Ytrunc(2),axisYLim(2)];
        ax3.XLim=[Xtrunc(2),axisXLim(2)];
        ax3.YLim=[Ytrunc(2),axisYLim(2)];
        ax4.XLim=[Xtrunc(2),axisXLim(2)];
        ax4.YLim=[axisYLim(1),Ytrunc(1)];
        % Relocating the ax locations
        ax.Position(3)=axisPos(3)*(1-truncRatio)/(axisXScale-diff(Xtrunc))*(Xtrunc(1)-axisXLim(1));
        ax.Position(4)=axisPos(4)*(1-truncRatio)/(axisYScale-diff(Ytrunc))*(Ytrunc(1)-axisYLim(1));
        ax2.Position(2)=axisPos(2)+ax.Position(4)+axisPos(4)*truncRatio;
        ax2.Position(3)=axisPos(3)*(1-truncRatio)/(axisXScale-diff(Xtrunc))*(Xtrunc(1)-axisXLim(1));
        ax2.Position(4)=axisPos(4)*(1-truncRatio)/(axisYScale-diff(Ytrunc))*(axisYLim(2)-Ytrunc(2));
        ax3.Position(1)=axisPos(1)+ax.Position(3)+axisPos(3)*truncRatio;
        ax3.Position(2)=axisPos(2)+ax.Position(4)+axisPos(4)*truncRatio;
        ax3.Position(3)=axisPos(3)*(1-truncRatio)/(axisXScale-diff(Xtrunc))*(axisXLim(2)-Xtrunc(2));
        ax3.Position(4)=axisPos(4)*(1-truncRatio)/(axisYScale-diff(Ytrunc))*(axisYLim(2)-Ytrunc(2));
        ax4.Position(1)=axisPos(1)+ax.Position(3)+axisPos(3)*truncRatio;
        ax4.Position(3)=axisPos(3)*(1-truncRatio)/(axisXScale-diff(Xtrunc))*(axisXLim(2)-Xtrunc(2));
        ax4.Position(4)=axisPos(4)*(1-truncRatio)/(axisYScale-diff(Ytrunc))*(Ytrunc(1)-axisYLim(1));
        % link the ax variation
        linkaxes([ax3,ax2],'y')
        linkaxes([ax4,ax3],'x')
        linkaxes([ax,ax2],'x')
        linkaxes([ax,ax4],'y')
        % Add lines and annotaions
        if strcmp(ax.Box,'on')
        ax.Box='off';ax2.Box='off';ax3.Box='off';ax4.Box='off';
        annotation('line',[ax.Position(1),ax.Position(1)+ax.Position(3)],[1,1].*(ax2.Position(2)+ax2.Position(4)),'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[ax3.Position(1),ax3.Position(1)+ax3.Position(3)],[1,1].*(ax2.Position(2)+ax2.Position(4)),'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[1,1].*(ax4.Position(1)+ax4.Position(3)),[ax3.Position(2),ax3.Position(2)+ax3.Position(4)],'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[1,1].*(ax4.Position(1)+ax4.Position(3)),[ax4.Position(2),ax4.Position(2)+ax4.Position(4)],'LineStyle','-','LineWidth',ax.LineWidth,'Color',ax.XColor);
        else
        annotation('line',[1,1].*(ax.Position(1)+ax.Position(3)),[ax2.Position(2),ax2.Position(2)+ax2.Position(4)],'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[1,1].*(ax3.Position(1)),[ax2.Position(2),ax2.Position(2)+ax2.Position(4)],'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[1,1].*(ax.Position(1)+ax.Position(3)),[ax.Position(2),ax.Position(2)+ax.Position(4)],'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[1,1].*(ax3.Position(1)),[ax.Position(2),ax.Position(2)+ax.Position(4)],'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[ax.Position(1),ax.Position(1)+ax.Position(3)],[1,1].*(ax.Position(2)+ax.Position(4)),'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[ax.Position(1),ax.Position(1)+ax.Position(3)],[1,1].*(ax2.Position(2)),'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[ax4.Position(1),ax4.Position(1)+ax4.Position(3)],[1,1].*(ax.Position(2)+ax.Position(4)),'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        annotation('line',[ax4.Position(1),ax4.Position(1)+ax4.Position(3)],[1,1].*(ax2.Position(2)),'LineStyle',':','LineWidth',ax.LineWidth,'Color',ax.XColor);
        end
        createSlash([ax.Position(1)-.2,ax.Position(2)+ax.Position(4)-.2,.4,.4])
        createSlash([ax.Position(1)-.2,ax2.Position(2)-.2,.4,.4])
        createSlash([ax4.Position(1)+ax4.Position(3)-.2,ax.Position(2)+ax.Position(4)-.2,.4,.4])
        createSlash([ax4.Position(1)+ax4.Position(3)-.2,ax2.Position(2)-.2,.4,.4])
        createSlash([ax.Position(1)+ax.Position(3)-.2,ax.Position(2)-.2,.4,.4])
        createSlash([ax.Position(1)+ax.Position(3)-.2,ax2.Position(2)+ax2.Position(4)-.2,.4,.4])
        createSlash([ax4.Position(1)-.2,ax.Position(2)-.2,.4,.4])
        createSlash([ax4.Position(1)-.2,ax2.Position(2)+ax2.Position(4)-.2,.4,.4])
        set(gcf,'currentAxes',ax3)
end
% Copy all the copyable properties of the original coordinate area
    function newAX=copyAxes(ax)
        axStruct=get(ax);
        fNames=fieldnames(axStruct);
        newAX=axes('Parent',ax.Parent);

        coeList={'CurrentPoint','XAxis','YAxis','ZAxis','BeingDeleted',...
            'TightInset','NextSeriesIndex','Children','Type','Legend'};
        for n=1:length(coeList)
            coePos=strcmp(fNames,coeList{n});
            fNames(coePos)=[];
        end
        
        for n=1:length(fNames)
            newAX.(fNames{n})=ax.(fNames{n});
        end

        copyobj(ax.Children,newAX)
    end
% Add truncation identifier function
    function createSlash(pos)
        anno=annotation('textbox');
        anno.String='/';
        anno.LineStyle='none';
        anno.FontSize=15;
        anno.Position=pos;
        anno.FitBoxToText='on';
        anno.VerticalAlignment='middle';
        anno.HorizontalAlignment='center';
    end
end